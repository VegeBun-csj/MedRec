var Patient_Wallet = require('../models/patient_wallet');
var Hospital_Wallet = require('../models/hospital_wallet');
var Orders = require('../models/orders');
var Medicine = require('../models/medicine');
exports.minusMoney = function(pid,yu_e,password,callback){

    Patient_Wallet.find({pid:pid},function(err,patient_wallet){
        if(patient_wallet[0].password===password)
        {
            patient_wallet[0].yu_e = yu_e;
            patient_wallet[0].save(function(err)
            {

                if(err)
                {
                    console.log('ERR:'+err);
                }
                return callback(0);
            });


        }
        else{


            return callback(1);
        }
       
        
    });


}
exports.HospitaladdMoney = function(hid,order_price,callback)
{

    Hospital_Wallet.find({hid:hid},function(err,hospital_wallet){
       
			console.log('医院的钱包余额'+hospital_wallet[0].yu_e);
            hospital_wallet[0].yu_e =  parseFloat(hospital_wallet[0].yu_e)+parseFloat(order_price);
            hospital_wallet[0].save(function(err)
            {

                if(err)
                {
                    console.log('ERR:'+err);
                }
                return callback(2);
            });

  
    });


}
exports.updateOrdersStatus_pay = function(oid,callback)
{
    Orders.find({oid:oid},function(err,orders)
    {
        orders[0].order_status = 1;

        orders[0].save(function(err)
        {
            if(err)
            {
                console.log('ERR: '+err);
            }
            return callback(3);
        });
    });

}

exports.updateMedicine_num = function(mid,order_count,callback)
{
    Medicine.find({mid:mid},function(err,medicine)
    {
        medicine[0].m_num =parseInt(medicine[0].m_num)  + parseInt(order_count) ;

        medicine[0].save(function(err)
        {
            if(err)
            {
                console.log('ERR: '+err);
            }
            return callback(1);


        })


    });


}

exports.updateOrdersStatus_cancel=function(oid,callback)
{
    Orders.find({oid:oid},function(err,orders)
    {
        orders[0].order_status = 2;

        orders[0].save(function(err)
        {
            if(err)
            {
                console.log('ERR: '+err);
            }
            return callback(0);
        });
    });


}

exports.isHaveWallet = function(pid,callback)
{   
    Patient_Wallet.count({ pid: pid }, function (err, count) {
           
        console.log('count: '+count);
        if(count===0)
        {
            return callback(1);
        }
        else{
            return callback (0);
        }
    });




}

exports.getWalletDetail=function(pid,callback)
{

   console.log("pid:"+pid);
    Patient_Wallet.find({ pid:pid },function(err,patient_wallet){
        
        //console.log(medicines.length);
        console.log(patient_wallet[0].yu_e);
        return callback(patient_wallet);

    });


};
exports.registerWallet = function(pid,p_wallet_name,password,callback){

        // Hospital.create({
        //     husername: username,
        //     hpassword: password
        // }, function(err, results) {

        
        //     return callback(err,results);
        // });

        Patient_Wallet.create({
            yu_e:0,
            pid: pid,
            p_wallet_name: p_wallet_name,
            password:password

        },function(err)
        {

            if(err)
            {
                console.log("ERR: "+err);
                
            }
            else{

                return callback(1);
            }

        });



}
exports.chongzhi = function(pid,amount,password,callback)
{
   
        Patient_Wallet.find({pid:pid},function(err,patient_wallet)
        {

            if(password === patient_wallet[0].password)
            {

                
                patient_wallet[0].yu_e =parseFloat(patient_wallet[0].yu_e) + parseFloat(amount) ;
                patient_wallet[0].save(function(err)
                {
                    if(err)
                    {
                        console.log('ERR: '+err);
                    }
                    return callback(1);
                });


            }
            else{

                return callback(0);
            }
           // console.log(patient_wallet[0].password+" cccccc");


        });

}

exports.changeWalletPassword = function(pid,oldpassword,newPassword,callback)
{

    Patient_Wallet.find({pid:pid},function(err,patient_wallet)
    {
        if(err)
        {
            console.log('ERR: '+err);
        }
        else{
            var password = patient_wallet[0].password;
            if(password != oldpassword)
            {

                return callback(0);
            }
            else{

                patient_wallet[0].password = newPassword;

                patient_wallet[0].save(function(err)
                {
                    if(err)
                    {
                        console.log('ERR: '+err);
                    }
                    else{

                        return callback(1);
                    }

                });


            }


        }
        





    });





};


