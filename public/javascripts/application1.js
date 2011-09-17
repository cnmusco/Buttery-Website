
//load after the page loads
$(document).ready(function()
{
    buttons();
}); 

function buttons()
{
    $("#log_in").click(function()
    {
        //If the other menu is showing, hide it before showing this one
        if($("#sign_up_menu").css("display")!="none")
        {
            $("#sign_up_menu").hide();
        }
        
        if($("#log_in_menu").css("display")=="none")
        {
            $("#invalid_login").hide();
            $("#log_in_menu").slideDown('fast', function(){});
        }
        else
        {
            $("#log_in_menu").slideUp('fast', function(){});
        }
    });
    
    $("#login_button").click(function()
    {
        if($("#email").val() && $("#pwd").val())
        {
            $("#log_in_menu").slideUp('fast', function(){});
        }
        else
        {
            $("#invalid_login").show();
        }
    });
    
    
     $("#sign_up_butt").click(function()
        {
            //If the other menu is showing, hide it before showing this one
            if($("#log_in_menu").css("display")!="none")
            {
                $("#log_in_menu").hide();
            }
            
            if($("#sign_up_menu").css("display")=="none")
            {
                $("#invalid_login1").hide();
                $("#sign_up_menu").slideDown('fast', function(){});
            }
            else
            {
                $("#sign_up_menu").slideUp('fast', function(){});
            }
    });
    
    $("#sign_up_button").click(function()
    {
        if($("#email").val() && $("#pwd").val())
        {
            $("#sign_up_menu").slideUp('fast', function(){});
        }
        else
        {
            $("#invalid_login1").show();
        }
    });
}