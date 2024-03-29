<?php
/*
 Plugin Name: Wordpress Click2Call
 Plugin URI: http://twilio.com
 Description: Allows theme developers to add click2call support to any post/page
 Version: 1.0.4
 Author: Adam Ballai
 Author URI: http://twilio.com
*/

if (!function_exists('add_action')) {
    $wp_root = '../../..';
    if (file_exists($wp_root.'/wp-load.php')) {
        require_once($wp_root.'/wp-load.php');
    } else {
        require_once($wp_root.'/wp-config.php');
    }
}
    
if(!class_exists('Click2call')) {

define('WP_CLICK2CALL_VERSION', '1.0.4');
require_once '../wp-click2call/twilio.php';

class Click2call {
    static $options = array('wpc2c_twilio_sid' => 'Twilio Account Sid',
                            'wpc2c_twilio_token' => 'Twilio Token',
                            'wpc2c_caller_id' => 'Caller ID',
                            'wpc2c_primary_phone' => 'Primary Phone To Call',
                            'wpc2c_primary_extension' => 'Primary Phone Extension (optional)',
                            'wpc2c_example_text' => 'Placeholder text',
                            'wpc2c_show_logo' => 'Show Twilio Logo',
                            'wpc2c_custom_greeting' => 'Custom greeting for caller',
                            );
    static $helptext = array('wpc2c_twilio_sid' => 'You can retrieve this if you login to your account or signup at <a href="http://twilio.com">Twilio</a>',
                             'wpc2c_twilio_token' => 'This can be found on your Twilio account dashboard, <a href="http://twilio.com">Twilio</a>',
                             'wpc2c_caller_id' => 'Must be a valid outgoing caller id approved by your Twilio account.',
                             'wpc2c_primary_phone' => 'What number do you want people to call you on?',
                             'wpc2c_primary_extension' => 'If you are behind an existing phone system, add your extension.',
                             'wpc2c_example_text' => 'This is the placholder text shown in your widget before someone starts typing their number.',
                             'wpc2c_show_logo' => 'Do you want to hide the Twilio logo?',
                             'wp2c2_custom_greeting' => 'Type in what you want the caller to be greeted with before connecting.',
                             );
    function init() {
        global $wpdb;

        register_activation_hook(__FILE__, array('Click2call',
                                                 'create_settings'));

        add_action('admin_menu', array('Click2call',
                                       'admin_menu'));

        add_action('wp_head', array('Click2call',
                                    'head_scripts'));
    }

    function dial($number) {
        $twilio = new TwilioRestClient(get_option('wpc2c_twilio_sid'),
                                       get_option('wpc2c_twilio_token'),
                                       'https://api.twilio.com/2008-08-01');
        $phone = get_option('wpc2c_primary_phone');
        $ext = get_option('wpc2c_primary_extension');
        $connecting_url = plugins_url('wp-click2call/wp-click2call.php?ext='.urlencode($ext).'&connect_to='.urlencode($phone));
        
        $response = $twilio->request("Accounts/".get_option('wpc2c_twilio_sid')."/Calls",
                                     'POST',
                                     array( "Caller" => get_option('wpc2c_caller_id'),
                                            "Called" => $number,
                                            "Url" => $connecting_url,
                                            )
                                     );

        $data = array('error' => false, 'message' => '');
        if($response->IsError) {
            $data['error'] = true;
            $data['message'] = $response->ErrorMessage;
        }

        echo json_encode($data);
    }

    function connect($number, $ext)
    {
        header('X-WP-Click2Call: '.WP_CLICK2CALL_VERSION);
        $twilio = new Response();
        $greeting = get_option('wpc2c_custom_greeting');
        if(!empty($greeting)) {
            $twilio->addSay($greeting);
        }
        $dial = $twilio->addDial();
        $dial_options = array();
        if(!empty($ext))
        {
            $dial_options = array('sendDigits' => $ext);
        }
        $dial->addNumber($number, $dial_options);
        $twilio->Respond();
    }

    function admin_menu() {
        
        add_menu_page('Click2call Options',
                      'Click2call',
                      8,
                      __FILE__,
                      array('Click2call',
                            'options'));
    }

    function head_scripts() {
        wp_enqueue_script('wp-click2call', plugins_url('wp-click2call/click2call.js'), array('jquery', 'swfobject'), WP_CLICK2CALL_VERSION, true);
        wp_localize_script('wp-click2call', 'click2callL10n', array(
                                                                    'plugin_url' => plugins_url('wp-click2call'),
                                                                    'exampletext' => htmlspecialchars(get_option('wpc2c_example_text')),
                                                                    'showlogo' => get_option('wpc2c_show_logo') == 'yes'? 1 : 0,
                                                                    ));
        wp_print_scripts('wp-click2call');
    }

    function options() {
        $message = '';
        if(!empty($_POST['submit'])) {
            self::update_settings($_POST);
            $message = "Settings have been updated";
        }
        echo '<div class="wrap">';
        echo '<h2>Click2Call</h2>';
        echo '<h3>'.$message.'</h3>';

        echo '<p>Step 1. To get started with setting up your click2call button, you first must get your Twilio Account Sid and Token.  Login or signup at <a href="http://twilio.com">twilio.com</a></p>';
        echo '<p>Step 2. Customize the settings below.</p>';
		echo '<p>Step 3. Drop this code snippet in your theme to create a click2call button</p>';
		echo '<p class="code">'.htmlspecialchars('<?php wp_c2c(); ?>')."</p>";
        echo '<form name="c2c-options" action="" method="post">';
        foreach(self::$options as $option => $title) {
            $value = get_option($option, '');
            $type = preg_match('/wpc2c_show_(.*)/', $option)? 'checkbox' : 'text';
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
    
    function create_settings() {
        add_option('wpc2c_twilio_sid', '',
                   'Twilio Account Sid',
                   'yes');
        
        add_option('wpc2c_twilio_token', '',
                   'Twilio Account Token',
                   'yes');
        
        add_option('wpc2c_primary_phone', '',
                   'Primary phone number to call',
                   'yes');

        add_option('wpc2c_primary_extension', '',
                   'Primary phone extension to dial',
                   'yes');

        add_option('wpc2c_caller_id', '',
                   'What to show up on your friends phone',
                   'yes');

        add_option('wpc2c_example_text', '(415) 867 5309',
                   'Example text',
                   'yes');

        add_option('wpc2c_show_logo', 'yes',
                   'Show Twilio logo',
                   'yes');
    }

    function update_settings($settings) {
        foreach(self::$options as $option => $title) {
            update_option($option, $settings[$option]);
        }
    }
    
}

/* Wordpres Tag for click2call */
function wp_c2c() {
    $c2c_id = "C2C".uniqid();
    echo '<div id="'.$c2c_id.'" class="click2call"></div>';
}

function wp_c2c_main() {
    
    if(!empty($_REQUEST['caller']))
    {
        Click2call::dial($_REQUEST['caller']);
        exit;
    }
    
    if(!empty($_REQUEST['connect_to']))
    {
        Click2call::connect($_REQUEST['connect_to'], $_REQUEST['ext']);
        exit;
    }
    
    return Click2call::init();
}

wp_c2c_main();
} // end class check
