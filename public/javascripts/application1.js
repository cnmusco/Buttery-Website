
//load after the page loads
$(document).ready(function()
{
    buttons();
}); 

function buttons()
{
    $("#worker_view").click(function()
    {
        window.location = "/worker/update_inventory"
    });
    
    $("#home").click(function()
    {
        window.location = "/home"
    });    
    
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
        if($("#username").val() && $("#pwd").val())
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
                $("#invalid_login2").hide();
                $("#sign_up_menu").slideDown('fast', function(){});
            }
            else
            {
                $("#sign_up_menu").slideUp('fast', function(){});
            }
    });
    
    $("#sign_up_button").click(function()
    {
        $("#invalid_login1").hide();
        $("#invalid_login2").hide();
        
        if(sign_up_validator())
        {
            $("#invalid_login2").show()
        }
        else if($("#email1").val() && $("#pwd0").val() && $("#pwd1").val() && $("#username1").val())
        {
            $("#sign_up_menu").slideUp('fast', function(){});
            alert("valid signup");
        }
        else
        {
            $("#invalid_login1").show();
        }
    });
    
    //functions for adding, subtracting and emptying inventroy
    $(".add_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        $(ais).html(parseInt($(ais).html(), 10)+1+'');
    });
    $(".sub_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        if(parseInt($(ais).html(), 10) >0)
            $(ais).html(parseInt($(ais).html(), 10)-1+'');
    });
    $(".empty_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        if(parseInt($(ais).html(), 10) >0)
            $(ais).html(0+'');
    });
}

function sign_up_validator()
{
    //passwords match?
    if($("#pwd1").val() != $("#pwd0").val())
    {
        return 1;
    }
    
    //valid yale email address
    var email=$("#email1").val();
    var flag1=0;
    for(var i=0; i<email.length; i++)
    {
        var letter=email.charAt(i);

        if(flag1 && letter=='@')
        {
            return !email.substr(i)=="@yale.edu";
        }
        else if(letter=='.')
        {
            flag1=1;
        }
    }
    
    return 1;
}