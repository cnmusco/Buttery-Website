
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
        var ids=new Array();
        var clas=$("#add_class").val();
        if(clas=="other")
            clas=$("#nmi_new_class").val();
        ids=$("#hidden_id_of_ings").text().split("  ");
        var ings=new Array(), vits=new Array;
        var name, clas, error=0, empty=0;
        if(!(name=$("#nmi_name").val()))
            alert("Enter A Name");
        else
        {
            for(var i=1; i<=num_ings; i++)
            {
                var j=parseInt(ids[i], 10);
                ings[i]=(!!$("#nmi_ing_"+j+":checkbox:checked").val());
                vits[i]=(!!$("#nmi_ing_"+j+"_vital:checkbox:checked").val());
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
                var ing_send=new Array();
                var vit_send=new Array();
                var count=0, last_val=1;
                for(var i=1; i<=num_ings; i++)
                {
                    var val=parseInt(ids[i], 10);
                    if(ings[i])
                    {
                        ing_send[count++]=val;
                        if(vits[i])
                            vit_send[val]=1;
                        else
                            vit_send[val]=0;
                        last_val=val;
                    }
                }
                for(var i=0; i<last_val; i++)
                {
                    if(vit_send[i]!=1)
                        vit_send[i]=0;
                }
                $.ajax({
                    type: "POST",
                    url: "add_itm",
                    data: ({
                        name: name,
                        clas: clas,
                        ings: ing_send.join(';'),
                        vits: vit_send.join(';')})
                });
                $("#nmi_name").val("")
                for(var i=1; i<=num_ings; i++)
                {
                    var j=parseInt(ids[i], 10);
                    $("#nmi_ing_"+j+":checkbox").removeAttr('checked');
                    $("#nmi_ing_"+j+"_vital:checkbox").removeAttr('checked');
                }
                $("#nmi_new_class").val("");
                alert("The " + name + " has been added to the inventory");
            }
        }
    });
    $("#add_class").change(function()
    {
        if($("#add_class").val()=="other")
            $("#nmi_new_class").show();
        else
            $("#nmi_new_class").hide();
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
    
    $("#edit_item").change(function()
    {
        edit_remove($("#edit_item").val());
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

//function updates the edit/remove section of the menu manger
function edit_remove(cur_itm)
{
    $.ajax({
        type: "POST",
        url: "add_ing_to_itm",
        data: ({current_item: cur_itm}),
        //dataType: "text",
        success: function(data)
                {
                    $("#all").html(data)
                }
    });
   // <tr><td> ing1.ingredient_name </td>
     //   <td> <input id=remove ing1.id  type=checkbox> </input>  </td></tr>
}