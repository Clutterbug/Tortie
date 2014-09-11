<?php
/*
* Plugin Name: Browser Record Plugin
* Plugin URI: http://www.tortie.co.uk/wordpress/
* Description: Twilio browser record
* Author: Clare Newall
* Version: 1.0.0
* Author URI: http://www.tortie.co.uk/
* License: GPLv2 or later
*/
?>

<?php
require_once 'Services/Twilio.php';

add_action( 'wp_enqueue_scripts', 'cn_load_scripts' );

function cn_load_scripts() {
    wp_register_style( 'browsrecCSS', plugins_url( 'browsrec.css', __FILE__ ) );
    wp_enqueue_style( 'browsrecCSS' );
    wp_enqueue_script( 'jquery' );
    wp_enqueue_script('twilio', 'http://static.twilio.com/libs/twiliojs/1.1/twilio.min.js'); 
}

add_shortcode( 'cn_browser_record', 'cn_browser_record_shortcode' );

function cn_browser_record_shortcode() { 
    // twilio account codes, found in twilio account
    // production
    $accountSid = 'ACffb19fe3b7d08d4aa16089e200b47061';
    $authToken  = '55b1273b328b91e083d44f551ccf3072';
    
    $token = new Services_Twilio_Capability($accountSid, $authToken);
    
    // production
    $token->allowClientOutgoing('AP3574db8be33441918142805cc0a10352');
    
    $output = '';
    $output .= '<div align="center">';
        $output .= '<input type="button" class="callbutton" id="call" value="Start Recording"/>';
        $output .= '<input type="button" class="stopbutton" id="stop" value="Stop Recording" style="display:none;"/>';
        $output .= '<div id="status">';
            $output .= 'Offline';
	$output .= '</div>';
    $output .= '</div>';
    $output .= '<script type="text/javascript">';
        $output .= 'jQuery(document).ready(function(){';
            $output .= 'Twilio.Device.setup("' . $token->generateToken() . '",{"debug":true});'; 
            $output .= 'jQuery("#call").click(function() {'; 
                $output .= 'Twilio.Device.connect();'; 
            $output .= '});';
            $output .= 'jQuery("#stop").click(function() {';
                $output .= 'connection.sendDigits("#");'; 
            $output .= '});';
            $output .= 'jQuery("#hangup").click(function() {'; 
                $output .= 'Twilio.Device.disconnectAll();'; 
            $output .= '});'; 
            $output .= 'Twilio.Device.ready(function (device) {'; 
                $output .= 'jQuery("#status").text("Ready to start recording");';
            $output .= '});'; 
            $output .= 'Twilio.Device.offline(function (device) {'; 
                $output .= 'jQuery("#status").text("Offline");';
            $output .= '});'; 
            $output .= 'Twilio.Device.error(function (error) {'; 
                $output .= 'jQuery("#status").text(error);'; 
            $output .= '});';
            $output .= 'Twilio.Device.connect(function (conn) {'; 
                $output .= 'connection=conn;'; 
		$output .= 'jQuery("#status").text("On Air");';
		$output .= 'jQuery("#status").css("color", "red");';
                $output .= 'toggleCallStatus();';
            $output .= '});';
            $output .= 'Twilio.Device.disconnect(function (conn) {'; 
		$output .= 'jQuery("#status").text("Recording ended");';
		$output .= 'jQuery("#status").css("color", "black");';
                $output .= 'toggleCallStatus();';
            $output .= '});';
            $output .= 'function toggleCallStatus(){'; 
                $output .= 'jQuery("#call").toggle();'; 
                $output .= 'jQuery("#stop").toggle();';
            $output .= '};';
        $output .= '})';
    $output .= '</script>';
    return $output;          
}

?>
