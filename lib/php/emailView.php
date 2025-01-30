<?php
    
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');
$da = date('Y-m-d H:i:s');
$date_now = date('Y-m-d');
session_start();
ini_set('display_errors', 'On');
    ?>


<!DOCTYPE html>
<html data-bs-theme="light" lang="en-US" dir="ltr">

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">


    <!-- ===============================================-->
    <!--    Document Title-->
    <!-- ===============================================-->
    <title>iAssist | HEL</title>


    <!-- ===============================================-->
    <!--    Favicons-->
    <!-- ===============================================-->
    <link rel="apple-touch-icon" sizes="180x180" href="../../CRM/public/assets/img/favicons/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../../CRM/public/assets/img/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../../CRM/public/assets/img/favicons/favicon-16x16.png">
    <link rel="shortcut icon" type="image/x-icon" href="../../CRM/public/assets/img/favicons/favicon.ico">
    <link rel="manifest" href="../../CRM/public/assets/img/favicons/manifest.json">
    <meta name="msapplication-TileImage" content="../../CRM/public/assets/img/favicons/mstile-150x150.png">
    <meta name="theme-color" content="#ffffff">
    <script src="../../CRM/public/assets/js/config.js"></script>
    <script src="../../CRM/public/vendors/simplebar/simplebar.min.js"></script>


    <!-- ===============================================-->
    <!--    Stylesheets-->
    <!-- ===============================================-->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,500,600,700%7cPoppins:300,400,500,600,700,800,900&amp;display=swap" rel="stylesheet">
    <link href="../../CRM/public/vendors/simplebar/simplebar.min.css" rel="stylesheet">
    <link href="../../CRM/public/assets/css/theme-rtl.css" rel="stylesheet" id="style-rtl">
    <link href="../../CRM/public/assets/css/theme.css" rel="stylesheet" id="style-default">
    <link href="../../CRM/public/assets/css/user-rtl.css" rel="stylesheet" id="user-style-rtl">
    <link href="../../CRM/public/assets/css/user.css" rel="stylesheet" id="user-style-default">
    <script>
      var isRTL = JSON.parse(localStorage.getItem('isRTL'));
      if (isRTL) {
        var linkDefault = document.getElementById('style-default');
        var userLinkDefault = document.getElementById('user-style-default');
        linkDefault.setAttribute('disabled', true);
        userLinkDefault.setAttribute('disabled', true);
        document.querySelector('html').setAttribute('dir', 'rtl');
      } else {
        var linkRTL = document.getElementById('style-rtl');
        var userLinkRTL = document.getElementById('user-style-rtl');
        linkRTL.setAttribute('disabled', true);
        userLinkRTL.setAttribute('disabled', true);
      }
    </script>
  </head>


  <body>

    <!-- ===============================================-->
    <!--    Main Content-->
    <!-- ===============================================-->
    <main class="main" id="top">
      <div class="container" data-layout="container">
        <script>
          var isFluid = JSON.parse(localStorage.getItem('isFluid'));
          if (isFluid) {
            var container = document.querySelector('[data-layout]');
            container.classList.remove('container');
            container.classList.add('container-fluid');
          }
        </script>
      
        <div class="content">
    
          <div class="card mb-3">
            <div class="card-body">
              <div class="row">
                <div class="col">
                  <div class="d-flex">
                
                    <div class="flex-1 fs--1">
                      <h5 class="fs-0">
                              <?php
							    
							    $contactNo="";
							    $logged_by = "";
							    $compName ="";
							    $inqId = "";
							    $inqDate = "";
							    $rid = $_GET['rid'];
							    
							        $qrt6="Select inquiry_details.inquiry_details_id,inquiry_details.logged_by,inquiry_details.inquiry_dateTime,customers.customer_company_name from inquiry_details inner join customers on inquiry_details.customer_id = customers.customer_id  where inquiry_refno='".$rid."'";
                      
        $result6 = mysqli_query($con_hel, $qrt6);

        if (mysqli_num_rows($result6) > 0) {

            while ($row6 = mysqli_fetch_assoc($result6)) {
                   $logged_by = $row6['logged_by'];   
				$inqDate = $row6['inquiry_dateTime'];
				$compName = $row6['customer_company_name'];
				$inqId =  $row6['inquiry_details_id'];
            }}
							    
							    
							        $qrt_HRIS = "Select NAME,Email_Address,Mobile from EMB_DB WHERE HRIS_NO ='".$logged_by."'";
                     //   echo $qrt_HRIS;
              $result_HRIS = mysqli_query($DB_HRIS_conn, $qrt_HRIS);
                  if ( mysqli_num_rows( $result_HRIS ) > 0 ) {
                      while ($row_HRIS = mysqli_fetch_assoc($result_HRIS)) {
                              echo $row_HRIS['NAME'];
                                $contactNo = $row_HRIS['Mobile'];
                      }}
							    
							    ?>
                          
                      </h5>
                      <p class="mb-0">Submitted On <a href="#!"><?php echo  $inqDate; ?></a></p>
                    </div>
                  </div>
                </div>
          
              </div>
            </div>
          </div>
          <div class="row g-0">
            <div class="col-lg-8 pe-lg-2">
              <div class="card mb-3 mb-lg-0">
                <div class="card-body">
                  <h5 class="fs-0 mb-3">Customer : <?php  echo $compName; ?> | Ref : <?php echo $rid; ?></h5>
                

			<p style="margin-top:0pt; margin-bottom:8pt">
				&#xa0;
			</p>
			<table cellspacing="0" cellpadding="0" style="width:486.5pt; border-collapse:collapse">
			
				<tr>
					<td style="width:122.6pt; border-style:solid; border-width:0.75pt; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top">
						<p style="margin-top:0pt; margin-bottom:0pt; font-size:11pt">
							<strong>Product Name</strong>
						</p>
					</td>
					<td colspan="11" style="width:341.55pt; border-style:solid; border-width:0.75pt; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top">
						<p style="margin-top:0pt; margin-bottom:0pt; font-size:11pt">
						Quantity
						</p>
					</td>
					<td colspan="11" style="width:341.55pt; border-style:solid; border-width:0.75pt; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top">
						<p style="margin-top:0pt; margin-bottom:0pt; font-size:11pt">
						Value
						</p>
					</td>
				</tr>
			<?php
			
		$qrt7 ="Select * from temp_inquiry_product inner join products on temp_inquiry_product.product_id = products.id where inquiry_id='".$inqId."'";
			
		$result7 = mysqli_query($con_hel, $qrt7);

        if (mysqli_num_rows($result7) > 0) {

        while ($row7 = mysqli_fetch_assoc($result7)) {
			
			?>
			
			    <tr>
					<td style="width:122.6pt; border-style:solid; border-width:0.75pt; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top">
						<p style="margin-top:0pt; margin-bottom:0pt; font-size:11pt">
							<strong><?php  echo $row7['product_name']; ?></strong>
						</p>
					</td>
					<td colspan="11" style="width:341.55pt; border-style:solid; border-width:0.75pt; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top">
						<p style="margin-top:0pt; margin-bottom:0pt; font-size:11pt">
							<?php  echo $row7['product_qty']; ?>
						</p>
					</td>
					<td colspan="11" style="width:341.55pt; border-style:solid; border-width:0.75pt; padding-right:5.03pt; padding-left:5.03pt; vertical-align:top">
						<p style="margin-top:0pt; margin-bottom:0pt; font-size:11pt">
							<?php  echo number_format($row7['total_value'],2); ?>
						</p>
					</td>
				</tr>
				
				
				<?php }} ?>
		
			</table>
		
		
                </div>
              </div>
            </div>
          
          </div>
   
        </div>
       
      </div>
    </main>
    <!-- ===============================================-->
    <!--    End of Main Content-->
    <!-- ===============================================-->


    <!-- ===============================================-->
    <!--    JavaScripts-->
    <!-- ===============================================-->
    <script src="../../CRM/public/vendors/popper/popper.min.js"></script>
    <script src="../../CRM/public/vendors/bootstrap/bootstrap.min.js"></script>
    <script src="../../CRM/public/vendors/anchorjs/anchor.min.js"></script>
    <script src="../../CRM/public/vendors/is/is.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyARdVcREeBK44lIWnv5-iPijKqvlSAVwbw&callback=initMap" async></script>
    <script src="../../CRM/public/vendors/fontawesome/all.min.js"></script>
    <script src="../../CRM/public/vendors/lodash/lodash.min.js"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=window.scroll"></script>
    <script src="../../CRM/public/vendors/list.js/list.min.js"></script>
    <script src="../../CRM/public/assets/js/theme.js"></script>

  </body>

</html>