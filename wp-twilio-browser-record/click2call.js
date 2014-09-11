var Click2Call = {
    reset : [],
    indicators : []
};

jQuery(document).ready(function() {
    jQuery('.click2call').each(function() {
        var flash_id = jQuery(this).attr('id');
        var params = {
        };
        swfobject.embedSWF(click2callL10n.plugin_url + '/dialer.swf?exampletext='+click2callL10n.exampletext+'&showlogo='+click2callL10n.showlogo, flash_id, '230px', '55px', '9.0.0');
        Click2Call.indicators.push(function() {
            jQuery('#'+flash_id).get(0).UpdateStatusIndicator(true);
        });
        Click2Call.reset.push(function() {
            jQuery('#'+flash_id).get(0).SetPhoneNumberValue('');
            jQuery('#'+flash_id).get(0).UpdateStatusIndicator(false);
        });
    });
});

var StartCall = function(caller) {
    for(var id in Click2Call.indicators) {
        Click2Call.indicators[id]();
    }
    if(caller && caller.length >= 9) {
        jQuery.ajax({
            url : click2callL10n.plugin_url + '/dialer.php',
            data : {
                caller : caller
            },
            success : function(data) {
                setTimeout(function() {
                    for(var id in Click2Call.reset) {
                        Click2Call.reset[id]();
                    }
                }, 10000);
            }
        });
    }
};

