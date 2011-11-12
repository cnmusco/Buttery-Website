var login_success = false;
var user_name = "";

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
            window.location = "/worker/orders"
    });
    $("#account_info").click(function()
    {
        window.location = "/account"
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
            $("#invalid_login5").hide();
            $("#invalid_login7").hide();
            
            $('#pwd').val('');
            $('#username').val('');
            $("#log_in_menu").slideDown('fast', function(){});
        }
        else
        {
            $("#log_in_menu").slideUp('fast', function(){});
        }
    });
	
	$("#login_form").submit(function(){
        $("#invalid_login").hide();
        $("#invalid_login5").hide();
        $("#invalid_login7").hide();
        
        if($("#username").val() && $("#pwd").val())
        {
            $.ajax({
            type: "POST",
            url: "/user_accounts/login",
            data: ({username: $("#username").val(),
                    pwd: $("#pwd").val()}),
			success: function() {
				if(login_success) {
					$("#log_in_menu").toggle();
					$("#nonworker_message").text("");
					$("#welcome-message").html("Welcome, " + user_name);
					$("#logged_in").show();
					$("#logged_out").hide();
					
				}
			}
            });
        }
        else
        {
            $("#invalid_login").show();
        }
		return false;
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
            $("#invalid_login3").hide();
            $("#invalid_login4").hide();
            $("#invalid_login6").hide();
            $('#email1').val('');
            $('#pwd0').val('');
            $('#pwd1').val('');
            $('#username1').val('');
            $("#sign_up_menu").slideDown('fast', function(){});
        }
        else
        {
            $("#sign_up_menu").slideUp('fast', function(){});
        }
    });
    
	$("#sign_up_form").submit(function()
    {
        $("#invalid_login1").hide();
        $("#invalid_login2").hide();
        $("#invalid_login3").hide();
        $("#invalid_login4").hide();
        $("#invalid_login6").hide();
        
        if(sign_up_validator())
        {
            $("#invalid_login2").show();
        }
        else if($("#email1").val() && $("#pwd0").val() && $("#pwd1").val() && $("#username1").val())
        {
			console.log("ajaxing");
            $.ajax({
            type: "POST",
            url: "/user_accounts/signup",
            data: ({email: $("#email1").val(),
                    username: $("#username1").val(),
                    pwd: $("#pwd1").val()})
            });
        }
        else
        {
            $("#invalid_login1").show();
        }
		return false;
    });
    
    
    
    //functions for adding, subtracting and emptying inventroy 
    //from worker inv page
    $(".add_item").click(function()
    {
        ing_id=this.id;
        var ais="#ais"+ing_id;
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
                    url: "add_items",
                    data: ({
                        name: name,
                        clas: clas,
                        ings: ing_send.join(';'),
                        flag: 4,
                        vits: vit_send.join(';')}),
                        success: function(data)
                                {
                                    $("#edit_items").html(data);
                                }
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
        var name, quant, unit, thresh;
        if((name=$("#ni_name").val()) && (quant=$("#ni_amount").val()) && parseInt(quant)==quant && (thresh=$("#ni_thresh").val()) && parseInt(thresh)==thresh&& (unit=$("#ni_unit").val()))
        {
            $.ajax({
                type: "POST",
                url: "add_items",
                data: ({
                    name: name,
                    flag: 5,
                    current_item: $("#edit_item_changer").val(),
                    amount: quant,
                    unit: unit,
                    thresh: thresh}),
                success: function(data)
                        {
                            $("#new_item").html(data);
                        }
            });
            
            $("#ni_name").val('');
            $("#ni_amount").val('');
            $("#ni_unit").val('');
            alert(name + " has been added to the inventory");
        }
        else
            alert("Invalid Input");
    });
    
    $("#edit_item_changer").live('change', function()
    {
        edit_remove($("#edit_item_changer").val());
    });
    
    
    //buttons for edit and delete menu items
    $("#update_menu_button").live('click',function()
    {
        var ings_to_be_removed=new Array();
        var ings_to_be_added=new Array();
        var vits_to_be_added=new Array();
        
        var ids=$("#hidden_id_of_ings").text().split("  ");
        var num_ings=parseInt($("#hidden_num_of_ings").text(), 10);
        var error=0;
        
        for(var i=1; i<=num_ings; i++)
        {
            cur_id=parseInt(ids[i], 10);
            var remove="#remove_ing_" + cur_id;
            var add="#add_ing_" + cur_id;
            var add_vit="#add_ing_" + cur_id + "_vital";
            
            //go through the remove
            if($(remove).attr('checked'))
                ings_to_be_removed.push(cur_id);
            
            //go through the additions
            if($(add).attr('checked'))
            {
                ings_to_be_added.push(cur_id);
                if($(add_vit).attr('checked'))
                    vits_to_be_added[cur_id]=1;
            }
            else if($(add_vit).attr('checked'))
                error=1;
        }
        for(var i=0; i<=parseInt(ids[num_ings], 10); i++)
        {
            if(!vits_to_be_added[i])
                vits_to_be_added[i]=0;
        }
        
        if(error)
            alert("An Ingredient Cannot Be Vital if it is Not Included");
        else if(ings_to_be_removed.length===0 && ings_to_be_added.length===0)
        {
            alert("You Have Not Made Any Changes");
        }
        else
        {
            //update the item
            $.ajax({
                type: "POST",
                url: "add_items",
                data: ({
                    flag: 2,
                    current_item: $("#edit_item_changer").val(),
                    remove: ings_to_be_removed.join(';'),
                    add: ings_to_be_added.join(';'),
                    vits: vits_to_be_added.join(';')}),
                    success: function(data)
                            {
                                $("#edit_items").html(data)
                                alert($('#current_itm_'+$("#edit_item_changer").val()).attr('class')+' was updated');
                            }
            });
        }
    });
    $("#delete_menu_button").click(function()
    {
        if(confirm("Are You Sure You Want To Delete This Item?"))
        {
            $.ajax({
                type: "POST",
                url: "add_items",
                data: ({current_item: $("#edit_item_changer").val(),
                        flag: 3}),
                success: function(data)
                    {
                        alert($('#current_itm_'+$("#edit_item_changer").val()).attr('class')+' was deleted');
                        $("#edit_items").html(data)
                    }
            });
        }
    });
    
    $(".item_names_public").click(function()
    {
        var val="#pub_ings_" + event.target.name;
        $(val).toggle();
    });
    
    
    //submit button on public page
    $("#submit_order").click(function()
    {
        var order=new Array();
        var last_parent='';
        $('.pub_ings_in_itms').each(function()
        {
            if($(this).is(":visible"))
            {
                var parent=$(this).attr('id');
                var value=$(this).val();
                if(last_parent!=parent)
                {
                    var tmp=order.pop();
                    if(tmp!=('|'+last_parent) && tmp)
                        order.push(tmp);
                    order.push('|'+parent);
                }
                if(value!=0)
                    order.push(','+$(this).attr('name')+':'+value);
                last_parent=parent;
            }
        });
         $.ajax({
                type: "POST",
                url: "/order/add_order",
                data: ({order: order.join(''),}),
            });
    });
    
    
    //order button on worker page
    $('#orders').click(function()
    {
        window.location="/worker/orders";
    });
    //begin making order button
    $(".order_is_cooking").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:0,
                        id: $(this).attr('id')})
            });
    });
    //finished order button
    $(".order_is_done").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:1,
                        id: $(this).attr('id')})
            });
    });
    //pickup order button
    $(".order_is_picked_up").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:2,
                        id: $(this).attr('id')})
            });
    });
    //finished order button
    $(".order_is_abandoned").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/order/view_order_queue",
                data: ({flag:3,
                        id: $(this).attr('id')})
            });
    });
    
    
    //button for account manager
    $("#change_pwd").click(function()
    {
        var old_pwd, new_pwd;
        
        //ensure that fields are correctly entered
        if((old_pwd=$("#acc_old_pwd").val()) && (new_pwd=$("#acc_new_pwd1").val()) &&
                    new_pwd==$("#acc_new_pwd2").val() && new_pwd!=old_pwd)
        {
            $.ajax({
                type: "POST",
                url: "account/change_pwd",
                data: ({old_pwd: old_pwd,
                        new_pwd: new_pwd})
            });
        }
    });
    
    //reset password
    $("#forgot_pwd").click(function()
    {
        var unm = $("#username").val();
        if(!unm)
            alert("Please Enter Your Username");
        else
        {
            $.ajax({
                type: "POST",
                url: "/account/reset_pwd",
                data: ({username: unm})
            });
            alert("An Email Has Been Sent To You");
        }
    });
    
    //log out
    $("#log_out").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/user_accounts/logout"
                });
    });
    
    
    //send stocking email
    $("#restock").click(function()
    {
        $.ajax({
                type: "POST",
                url: "/worker/restock"
                });
    });
    
    
    //cancel order on account page
    $('.acc_order_cancel').click(function()
    {
        $.ajax({
                type: "POST",
                url: "/account/cancel_order",
                data: ({ord_id: $(this).attr('id')})
                });
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
        url: "add_items",
        data: ({flag: 1,
                current_item: cur_itm}),
        success: function(data)
                {
                    $("#edit_items").html(data);
                }
    });
}
