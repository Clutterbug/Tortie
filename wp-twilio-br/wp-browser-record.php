<?php

/*
 Plugin Name: Wordpress Browser Record
 Plugin URI: http://www.tortie.co.uk
 Description: Allows theme developers to add twilio browser record functionality to any post/page
 Version: 1.0.0
 Author: Clare Newall
 Author URI: http://www.tortie.co.uk
*/
if (!function_exists('add_action')) {
    $wp_root = '../../..';
    if (file_exists($wp_root.'/wp-load.php')) {
        require_once($wp_root.'/wp-load.php');
    } else {
        require_once($wp_root.'/wp-config.php');
    }
}
if(!class_exists('BrowserRecord')) {
    
    define('WP_BROWSER_RECORD_VERSION', '1.0.0');
    require_once 'Services/Twilio.php';
    
    class BrowserRecord {
        static $options = array('wpbr_twilio_ac_sid' => 'Twilio Account Sid',
                                'wpbr_twilio_token' => 'Twilio Token',
                                'wpbr_twilio_ap_sid' => 'Twilio Application Sid',
                                );
        
        static $helptext = array('wpbr_twilio_ac_sid' => 'You can retrieve this if you login to your account or signup at <a href="http://twilio.com">Twilio</a>',
                                'wpbr_twilio_token' => 'This can be found on your Twilio account dashboard, <a href="http://twilio.com">Twilio</a>',
                                'wpbr_twilio_ap_sid' => 'This can be found on your Twilio account dashboard under "DEV TOOLS > TWIML APPS", <a href="http://twilio.com">Twilio</a>',
                                );
        
        function init() {
            global $wpdb;

            register_activation_hook(__FILE__, array('BrowserRecord','create_settings'));

            add_action('admin_menu', array('BrowserRecord','admin_menu'));

            add_action('wp_head', array('BrowserRecord','head_scripts'));
        }
        
        function create_settings() {
            add_option('wpbr_twilio_ac_sid', '',
                        'Twilio Account Sid',
                        'yes');
        
            add_option('wpbr_twilio_token', '',
                       'Twilio Account Token',
                       'yes');
        
            add_option('wpbr_twilio_ac_sid', '',
                       'Twilio Application Sid',
                       'yes');
        }
        function admin_menu() {
            add_menu_page('BrowserRecord Options',
                      'BrowserRecord',
                      8,
                      __FILE__,
                      array('BrowserRecord',
                            'options'));
        }
        function head_scripts() {
            wp_register_style( 'browsrecCSS', plugins_url( 'browsrec.css', __FILE__ ) );
            wp_enqueue_style( 'browsrecCSS' );
            wp_enqueue_script( 'jquery' );
            wp_enqueue_script('twilio', 'http://static.twilio.com/libs/twiliojs/1.1/twilio.min.js'); 
        }
        
        function options() {
            
            $message = '';
            if(!empty($_POST['submit'])) {
                self::update_settings($_POST);
                $message = "Settings have been updated";
            }
            echo '<div class="wrap">';
            echo '<h2>Browser Record</h2>';
            echo '<h3>'.$message.'</h3>';

            echo '<p>Step 1. Add your Twilio Account Sid and Token.  Login or signup at <a href="http://twilio.com">twilio.com</a></p>';
            echo '<p>Step 2. Drop this code snippet in your theme to create a Browser Record button</p>';
            echo '<p class="code">'.htmlspecialchars('<?php wp_br(); ?>')."</p>";
            echo '<form name="br-options" action="" method="post">';
            foreach(self::$options as $option => $title) {
                $value = get_option($option, '');
                $type = preg_match('/wpbr_show_(.*)/', $option)? 'checkbox' : 'text';
                $checked = '';
                if($type == 'checkbox') {
                    if($value == 'yes') {
                        $checked = 'checked="checked"';
                    }
                    $value = "yes";
                }
                echo '<div id="'.htmlspecialchars($option).'_div" class="stuffbox">';
                echo '<h3 style="margin:0; padding: 10px">';
                echo '<label for="'.htmlspecialchars($option).'">'.htmlspecialchars($title).'</label>';
                echo '</h3>';
                echo '<div class="inside" style="margin: 10px">';
                echo '<input id="'.htmlspecialchars($option).'" type="'.$type.'" name="'.htmlspecialchars($option).'" value="'.htmlspecialchars($value).'" '.$checked.' size="50"/>';
                echo '<p style="margin: 10px">'.self::$helptext[$option].'</p>';
                echo '</div>';
                echo '</div>';
                 
            }
            echo '<input type="submit" name="submit" value="Save" />';

            echo '</form>';
            echo '</div>';
        }
        
        function update_settings($settings) {
            foreach(self::$options as $option => $title) {
                update_option($option, $settings[$option]);
            }
        }
        
        function connect_mailbox(){
            
            $token = new Services_Twilio_Capability(get_option('wpbr_twilio_ac_sid'),
                                                    get_option('wpbr_twilio_token'));
    
            $token->allowClientOutgoing(get_option('wpbr_twilio_ap_sid'));
            
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
             
            echo $output;
             
        }
        
    }
    
    /* Wordpres Tag for browser record */
    function wp_br() {
        BrowserRecord::connect_mailbox();
    }
    
    add_shortcode( 'wp_browser_record', 'wp_br' );

    function wp_br_main() {
        return BrowserRecord::init();
    }

    wp_br_main();
    
}// end class check