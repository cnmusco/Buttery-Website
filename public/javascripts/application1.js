
//load after the page loads
$(document).ready(function()
{
    buttons();
}); 

function buttons()
{
    //button link chnages
    $("#worker_view").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker");
        if(!(str.match(y)))
            window.location = "/worker/update_inventory"
    });
    $("#home").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/home");
        if(!(str.match(y)))
            window.location = "/home"
    });
    $("#up_inv").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker/update_inventory");
        if(!(str.match(y)))
            window.location = "/worker/update_inventory"
    });   
    $("#new_stuff").click(function()
    {
        var str=window.location.href;
        var y=new RegExp("/worker/manage_menu");
        if(!(str.match(y)))
            window.location = "/worker/manage_menu"
    });
    
    
    
    //log in and sign up buttons
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
    //from worker inv page
    $(".add_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        $(ais).html(parseInt($(ais).html(), 10)+1+'');
        $.ajax({
            type: "POST",
            url: "add_inv",
            data: ({id: ing_id})
        });
        
    });
    $(".sub_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        if(parseInt($(ais).html(), 10) >0)
            $(ais).html(parseInt($(ais).html(), 10)-1+'');
        $.ajax({
            type: "POST",
            url: "sub_inv",
            data: ({id: ing_id})
        });
    });
    $(".empty_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
        $(ais).html(0+'');
        $.ajax({
            type: "POST",
            url: "empty_inv",
            data: ({id: ing_id})
        });
    });
    
    
    //Buttons for Menu Manager
    $("#nmi_submit").click(function()
    {
        var num_ings=parseInt($("#hidden_num_of_ings").text(), 10);
        var ings=new Array(), vits=new Array;
        var name, clas, error=0, empty=0;
        if(!(name=$("#nmi_name").val()))
            alert("Enter A Name");
        else
        {
            for(var i=1; i<=num_ings; i++)
            {
                ings[i]=(!!$("#nmi_ing_"+i+":checkbox:checked").val());
                vits[i]=(!!$("#nmi_ing_"+i+"_vital:checkbox:checked").val());
                if(!((ings[i] && vits[i]) || !vits[i]))
                    error=1;
                if(ings[i])
                    empty++;
            }
            if(error)
                alert("An Ingredient Cannot Be Vital If It Is Not Included");
            else if(!empty)
                alert(name + " needs ingredients");
            else
            {
                $.ajax({
                    type: "POST",
                    url: "add_itm",
                    data: ({
                        name: name,
                        clas: clas,
                        ings: ings,
                        vits: vits})
                });
            }
        }
    });
    $("#ni_submit").click(function()
    {
        var name, quant, unit;
        if((name=$("#ni_name").val()) && (quant=$("#ni_amount").val()) && parseInt(quant)==quant && (unit=$("#ni_unit").val()))
        {
            $.ajax({
                type: "POST",
                url: "add_ing",
                data: ({
                    name: name,
                    amount: quant,
                    unit: unit})
            });
            
            $("#ni_name").val("");
            $("#ni_amount").val("");
            $("#ni_unit").val("");
            alert(name + " have been added to the inventory");
        }
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