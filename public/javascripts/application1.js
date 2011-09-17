
//load after the page loads
$(document).ready(function()
{
    buttons();
    //$("#log_in_menu").hide();
}); 

function buttons()
{
    $("#log_in").click(function()
    {
        if($("#log_in_menu").css("display")=="none")
        {
            $("#log_in_menu").slideDown('fast', function(){});
        }
        else
        {
            $("#log_in_menu").slideUp('fast', function(){});
        }
    });
    
    $("#login_button").click(function()
    {
        if($("#netid").val() && $("#pwd").val())
        {
            $("#log_in_menu").slideUp('fast', function(){});
        }
    });
}