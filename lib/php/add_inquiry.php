<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

require './PHPMailer/src/PHPMailer.php';
require './PHPMailer/src/SMTP.php';
require './PHPMailer/src/Exception.php';


include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');



// Retrieve POST data
$refNo = $_POST['refNo'] ?? '';
$Hris = $_POST['userHris'] ?? '';
$customerId = $_POST['customerId'] ?? '';
$productId = $_POST['product'] ?? '';
$qty = $_POST['qty'] ?? 0;
$proValue = $_POST['proValue'] ?? 0;

// Current date and time
$da = date('Y-m-d H:i:s'); // Inquiry creation date
$da1 = date('Y-m-d H:i:s'); // Last follow-up date

// Check for required fields
if (empty($refNo) || empty($customerId) || empty($productId)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required fields']);
    exit;
}

try {
    // Check if inquiry already exists
    $checkQuery = "SELECT inquiry_details_id FROM inquiry_details WHERE inquiry_refno = ?";
    $stmt = $con_hel->prepare($checkQuery);
    $stmt->bind_param('s', $refNo);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $insertedId = $row['inquiry_details_id'];
    } else {
        // Insert new inquiry
        $insertQuery = "INSERT INTO inquiry_details 
                        (inquiry_refno, inquiry_dateTime, customer_id, logged_by, inquiry_last_status) 
                        VALUES (?, ?, ?, ?, 'ONGOING')";
        $stmt = $con_hel->prepare($insertQuery);
        $stmt->bind_param('sssi', $refNo, $da, $customerId, $Hris);

        if (!$stmt->execute()) {
            throw new Exception('Failed to create inquiry: ' . $stmt->error);
        }

        $insertedId = $con_hel->insert_id;
    }

    // Insert product into temp_inquiry_product
    $productQuery = "INSERT INTO temp_inquiry_product 
                     (inquiry_id, product_id, product_qty, total_value, last_followup_date, last_status, submitted_dateTime) 
                     VALUES (?, ?, ?, ?, ?, 'TEMP', ?)";
    $stmt = $con_hel->prepare($productQuery);
    $stmt->bind_param('iiidss', $insertedId, $productId, $qty, $proValue, $da1, $da);

    if (!$stmt->execute()) {
        throw new Exception('Failed to add product: ' . $stmt->error);
    }

    // Fetch the updated product list
    $fetchQuery = "SELECT temp_inquiry_product.total_value, temp_inquiry_product.product_qty, 
                          customers.customer_company_name, products.product_name 
                   FROM temp_inquiry_product 
                   INNER JOIN inquiry_details ON temp_inquiry_product.inquiry_id = inquiry_details.inquiry_details_id 
                   INNER JOIN customers ON inquiry_details.customer_id = customers.customer_id 
                   INNER JOIN products ON temp_inquiry_product.product_id = products.id 
                   WHERE temp_inquiry_product.inquiry_id = ?";
    $stmt = $con_hel->prepare($fetchQuery);
    $stmt->bind_param('i', $insertedId);
    $stmt->execute();
    $result = $stmt->get_result();

    $productList = [];
    $customerCompanyName = '';
    $productName = '';

    while ($row = $result->fetch_assoc()) {
        $productList[] = $row;
        // Assign values to variables
        $customerCompanyName = $row['customer_company_name'];
        $productName = $row['product_name'];
    }

    // Send an email notification
    $mail = new PHPMailer(true);

    try {
        $mail->isSMTP();
        $mail->SMTPDebug = 0; // Set to 2 for verbose debug output if needed
        $mail->SMTPAuth = true;
        $mail->SMTPSecure = 'tls';
        $mail->Port = 587;
        $mail->Host = 'smtp.hostinger.com';
        $mail->Username = 'feedback@smartconnect.lk';
        $mail->Password = 'P1n3@ppl3@12345678'; // **Move this to an environment variable for security**
        $mail->setFrom("hayleys.electronics@smartconnect.lk", "HEL");

        // Add recipient
        $mail->AddAddress('udariweeraman@gmail.com');

        // Email subject and body
        $mail->Subject = "Inquiry Details of REF NO: " . $refNo;
        $mail->isHTML(true);
        $mail->Body = '<!DOCTYPE html><html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" lang="en"><head><title></title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><!--[if mso]><xml><o:OfficeDocumentSettings><o:PixelsPerInch>96</o:PixelsPerInch><o:AllowPNG/></o:OfficeDocumentSettings></xml><![endif]--><!--[if !mso]><!--><link 
href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;700&amp;display=swap" rel="stylesheet" type="text/css"><!--<![endif]--><style>
*{box-sizing:border-box}body{margin:0;padding:0}a[x-apple-data-detectors]{color:inherit!important;text-decoration:inherit!important}#MessageViewBody a{color:inherit;text-decoration:none}p{line-height:inherit}.desktop_hide,.desktop_hide table{mso-hide:all;display:none;max-height:0;overflow:hidden}.image_block img+div{display:none}sub,sup{font-size:75%;line-height:0} @media (max-width:740px){.mobile_hide{display:none}.row-content{width:100%!important}.stack .column{width:100%;display:block}.mobile_hide{min-height:0;max-height:0;max-width:0;overflow:hidden;font-size:0}.desktop_hide,.desktop_hide table{display:table!important;max-height:none!important}.row-5 .column-1 .block-1.text_block td.pad{padding:10px 30px!important}.row-4 .column-1 .block-1.button_block td.pad{padding:10px 20px!important}.row-4 .column-1 .block-1.button_block div,.row-4 .column-1 .block-1.button_block span{font-size:20px!important;line-height:40px!important}.row-2 .column-1{padding:25px 30px 5px!important}}
</style><!--[if mso ]><style>sup, sub { font-size: 100% !important; } sup { mso-text-raise:10% } sub { mso-text-raise:-10% }</style> <![endif]--></head><body class="body" style="background-color:#fff;margin:0;padding:0;-webkit-text-size-adjust:none;text-size-adjust:none"><table class="nl-container" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#fff"><tbody><tr><td><table class="row row-1" align="center" 
width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td><table class="row-content stack" align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#fff;border-radius:0;color:#000;width:720px;margin:0 auto" width="720"><tbody><tr><td class="column column-1" width="100%" 
style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="image_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad" style="width:100%"><div class="alignment" align="center" style="line-height:10px"><div style="max-width:720px"><img 
src="https://d15k2d11r6t6rl.cloudfront.net/pub/r388/l239mmxz/v4g/ghq/mee/Purple%20Modern%20Electronic%20Sale%20Twitter%20Post.png" style="display:block;height:auto;border:0;width:100%" width="720" alt title height="auto"></div></div></td></tr></table><table class="divider_block block-2" width="100%" border="0" cellpadding="10" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad"><div class="alignment" align="center"><table border="0" 
cellpadding="0" cellspacing="0" role="presentation" width="100%" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="divider_inner" style="font-size:1px;line-height:1px;border-top:1px solid #bbb"><span style="word-break: break-word;">&#8202;</span></td></tr></table></div></td></tr></table></td></tr></tbody></table></td></tr></tbody></table><table class="row row-2" align="center" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" 
style="mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td><table class="row-content stack" align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#fff;border-radius:0;color:#000;width:720px;margin:0 auto" width="720"><tbody><tr><td class="column column-1" width="100%" 
style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:5px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="text_block block-1" width="100%" border="0" cellpadding="10" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad"><div style="font-family:sans-serif"><div class 
style="font-size:14px;font-family:Arial,"Helvetica Neue",Helvetica,sans-serif;mso-line-height-alt:16.8px;color:#881bb2;line-height:1.2"><p style="margin:0;font-size:14px;mso-line-height-alt:16.8px"><strong><span style="word-break: break-word; font-size: 20px;">INQUIRY DETAILS</span></strong></p></div></div></td></tr></table><table class="image_block block-2" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td 
class="pad" style="width:100%"><div class="alignment" align="center" style="line-height:10px"><div style="max-width:98px"><img src="https://d15k2d11r6t6rl.cloudfront.net/pub/r388/l239mmxz/1ee/9sm/q6w/RR100.png" style="display:block;height:auto;border:0;width:100%" width="98" alt title height="auto"></div></div></td></tr></table><table class="text_block block-3" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" 
style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" style="padding-bottom:10px;padding-left:10px;padding-right:10px;padding-top:20px"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#881bb2;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px">
<span style="word-break: break-word; font-size: 15px;"><strong>REFERENCE NO:</strong></span></p></div></div></td></tr></table><table class="text_block block-4" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" style="padding-bottom:20px;padding-left:20px;padding-right:20px"><div style="font-family:Arial,sans-serif"><div class 
style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#000;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px"><span style="word-break: break-word; font-size: 12px;"><strong>'.$refNo.'</strong></span></p></div></div></td></tr></table></td></tr></tbody></table></td></tr></tbody></table><table class="row row-3" align="center" width="100%" border="0" cellpadding="0" cellspacing="0" 
role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td><table class="row-content stack" align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#fff;border-radius:0;color:#000;width:720px;margin:0 auto" width="720"><tbody><tr><td class="column column-1" width="25%" 
style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:35px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="image_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad" style="width:100%"><div class="alignment" align="center" style="line-height:10px"><div 
style="max-width:98px"><img src="https://d15k2d11r6t6rl.cloudfront.net/pub/r388/l239mmxz/1ee/9sm/q6w/RR100.png" style="display:block;height:auto;border:0;width:100%" width="98" alt title height="auto"></div></div></td></tr></table><table class="text_block block-2" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" 
style="padding-bottom:10px;padding-left:10px;padding-right:10px;padding-top:15px"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#881bb2;line-height:1.2"><p style="margin:0;text-align:center;mso-line-height-alt:16.8px"><span style="word-break: break-word; font-size: 15px;"><strong>CUSTOMER</strong></span></p></div></div></td></tr></table><table 
class="text_block block-3" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#000;line-height:1.2"><p style="margin:0;text-align:center;mso-line-height-alt:16.8px"><strong>'.$customerCompanyName.'</strong></p></div></div></td></tr>
</table></td><td class="column column-2" width="25%" style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:30px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="image_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad" style="width:100%"><div class="alignment" align="center" 
style="line-height:10px"><div style="max-width:98px"><img src="https://d15k2d11r6t6rl.cloudfront.net/pub/r388/l239mmxz/1ee/9sm/q6w/RR100.png" style="display:block;height:auto;border:0;width:100%" width="98" alt title height="auto"></div></div></td></tr></table><table class="text_block block-2" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" 
style="padding-bottom:10px;padding-left:10px;padding-right:10px;padding-top:20px"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#881bb2;line-height:1.2"><p style="margin:0;text-align:center;mso-line-height-alt:16.8px"><span style="word-break: break-word; font-size: 15px;"><strong>PRODUCT</strong></span></p></div></div></td></tr></table><table 
class="text_block block-3" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#000;line-height:1.2"><p style="margin:0;text-align:center;mso-line-height-alt:16.8px">
<span style="word-break: break-word; font-size: 12px;"><strong>'.$productName.'</strong></span></p></div></div></td></tr></table></td><td class="column column-3" width="25%" style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:30px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="image_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" 
style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad" style="width:100%"><div class="alignment" align="center" style="line-height:10px"><div style="max-width:98px"><img src="https://d15k2d11r6t6rl.cloudfront.net/pub/r388/l239mmxz/1ee/9sm/q6w/RR100.png" style="display:block;height:auto;border:0;width:100%" width="98" alt title height="auto"></div></div></td></tr></table><table class="text_block block-2" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" 
style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" style="padding-bottom:10px;padding-left:10px;padding-right:10px;padding-top:20px"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#881bb2;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px">
<span style="word-break: break-word; font-size: 15px;"><strong>QUANTITY</strong></span></p></div></div></td></tr></table><table class="text_block block-3" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad"><div style="font-family:Arial,sans-serif"><div class 
style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#000;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px"><span style="word-break: break-word; font-size: 12px;"><strong>'.$qty.'</strong></span></p></div></div></td></tr></table></td><td class="column column-4" width="25%" 
style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:30px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="image_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad" style="width:100%"><div class="alignment" align="center" style="line-height:10px"><div style="max-width:98px"><img 
src="https://d15k2d11r6t6rl.cloudfront.net/pub/r388/l239mmxz/1ee/9sm/q6w/RR100.png" style="display:block;height:auto;border:0;width:100%" width="98" alt title height="auto"></div></div></td></tr></table><table class="text_block block-2" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" style="padding-bottom:10px;padding-left:10px;padding-right:10px;padding-top:20px"><div 
style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#881bb2;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px"><span style="word-break: break-word; font-size: 15px;"><strong>TOTAL VALUE</strong></span></p></div></div></td></tr></table><table class="text_block block-3" width="100%" border="0" cellpadding="0" cellspacing="0" 
role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad"><div style="font-family:Arial,sans-serif"><div class style="font-size:14px;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;mso-line-height-alt:16.8px;color:#000;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px"><span style="word-break: break-word; font-size: 12px;"><strong>'.$proValue.'</strong></span></p></div></div></td></tr>
</table></td></tr></tbody></table></td></tr></tbody></table><table class="row row-4" align="center" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td><table class="row-content stack" align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#fff;border-radius:0;color:#000;width:720px;margin:0 auto" width="720"><tbody><tr><td 
class="column column-1" width="100%" style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:5px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="button_block block-1" width="100%" border="0" cellpadding="10" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad"><div class="alignment" align="center"><!--[if mso]>
<v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" style="height:44px;width:357px;v-text-anchor:middle;" arcsize="32%" stroke="false" fillcolor="#881bb2">
<w:anchorlock/>
<v:textbox inset="0px,0px,0px,0px">
<center dir="false" style="color:#ffffff;font-family:Arial, sans-serif;font-size:17px">
<![endif]--><div class="button" style="background-color:#881bb2;border-bottom:0 solid transparent;border-left:0 solid transparent;border-radius:14px;border-right:0 solid transparent;border-top:0 solid transparent;color:#fff;display:inline-block;font-family:"Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;font-size:17px;font-weight:700;mso-border-alt:none;padding-bottom:5px;padding-top:5px;text-align:center;text-decoration:none;width:auto;word-break:keep-all">
<span style="word-break: break-word; padding-left: 60px; padding-right: 60px; font-size: 17px; display: inline-block; letter-spacing: normal;"><span style="word-break: break-word; line-height: 34px;">Product Added Successfully!</span></span></div><!--[if mso]></center></v:textbox></v:roundrect><![endif]--></div></td></tr></table><div class="spacer_block block-2" style="height:40px;line-height:40px;font-size:1px">&#8202;</div></td></tr></tbody></table></td></tr></tbody></table><table 
class="row row-5" align="center" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td><table class="row-content stack" align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#881bb2;border-radius:0;color:#000;width:720px;margin:0 auto" width="720"><tbody><tr><td class="column column-1" width="100%" 
style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:5px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="text_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;word-break:break-word"><tr><td class="pad" style="padding-bottom:10px;padding-left:60px;padding-right:60px;padding-top:10px"><div 
style="font-family:sans-serif"><div class style="font-size:14px;font-family:Arial,"Helvetica Neue",Helvetica,sans-serif;mso-line-height-alt:16.8px;color:#fff;line-height:1.2"><p style="margin:0;font-size:14px;text-align:center;mso-line-height-alt:16.8px">For the more details of this inquiry, Please visit the HEL website or HEL&nbsp; Mobile App</p></div></div></td></tr></table></td></tr></tbody></table></td></tr></tbody></table><table class="row row-6" align="center" width="100%" border="0" 
cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td><table class="row-content stack" align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0;background-color:#fff;border-radius:0;color:#000;width:720px;margin:0 auto" width="720"><tbody><tr><td class="column column-1" width="100%" 
style="mso-table-lspace:0;mso-table-rspace:0;font-weight:400;text-align:left;padding-bottom:5px;padding-top:5px;vertical-align:top;border-top:0;border-right:0;border-bottom:0;border-left:0"><table class="empty_block block-1" width="100%" border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0;mso-table-rspace:0"><tr><td class="pad"><div></div></td></tr></table></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table><!-- End --><div style="background-color:transparent;">
    <div style="Margin: 0 auto;min-width: 320px;max-width: 500px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;" class="block-grid ">
        <div style="border-collapse: collapse;display: table;width: 100%;background-color:transparent;">
            <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="background-color:transparent;" align="center"><table cellpadding="0" cellspacing="0" border="0" style="width: 500px;"><tr class="layout-full-width" style="background-color:transparent;"><![endif]-->
            <!--[if (mso)|(IE)]><td align="center" width="500" style=" width:500px; padding-right: 0px; padding-left: 0px; padding-top:15px; padding-bottom:15px; border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent;" valign="top"><![endif]-->
            <div class="col num12" style="min-width: 320px;max-width: 500px;display: table-cell;vertical-align: top;">
                <div style="background-color: transparent; width: 100% !important;">
                    <!--[if (!mso)&(!IE)]><!--><div style="border-top: 0px solid transparent; border-left: 0px solid transparent; border-bottom: 0px solid transparent; border-right: 0px solid transparent; padding-top:15px; padding-bottom:15px; padding-right: 0px; padding-left: 0px;">
                        <!--<![endif]-->


                        <div align="center" class="img-container center  autowidth " style="padding-right: 0px;  padding-left: 0px;">
                            <!--[if mso]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding-right: 0px; padding-left: 0px;" align="center"><![endif]-->

                           
                            <!--[if mso]></td></tr></table><![endif]-->
                        </div>


                        <!--[if (!mso)&(!IE)]><!-->
                    </div><!--<![endif]-->
                </div>
            </div>
            <!--[if (mso)|(IE)]></td></tr></table></td></tr></table><![endif]-->
        </div>
    </div>
</div></body></html>';

        if (!$mail->send()) {
            throw new Exception('Email sending failed: ' . $mail->ErrorInfo);
        }
    } catch (Exception $e) {
        // Log email error but do not fail the request
        error_log("Email Error: " . $e->getMessage());
    }

    echo json_encode(['success' => 'Product added successfully', 'products' => $productList]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}

?>
