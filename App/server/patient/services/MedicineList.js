var Medicine = require('../models/medicine');
var Wishlist = require('../models/wishlist');

exports.getMedicineList = function(pid,hid,callback){

   
   /* Medicine.find().all(function(err,medicines){
    
        //console.log(medicines.length);
        console.log(medicines[0].m_name);
        return callback(err,medicines);

    });*/
	
	Medicine.find({hid:hid},function(err,medicines)
		{
			
		console.log(medicines[0].m_name);
        return callback(err,medicines);
	
		})
	

};



exports.searchMedicineByType= function(hid,m_type,callback)

{
	
	
		
	Medicine.find({hid:hid,m_type:m_type},function(err,medicines)
		{
			
		console.log(medicines[0]);
        return callback(err,medicines);
	
		})
	
	
	
	
	
};

exports.searchMedicineByName= function(hid,m_name,callback)

{
	
	
		
	Medicine.find({hid:hid,m_name:m_name},function(err,medicines)
		{
			
		console.log(medicines[0]);
        return callback(err,medicines);
	
		})
	
	
	
	
	
};


exports.updateKucun = function(mid,m_num,callback){

    Medicine.find({mid:mid},function(err,medicine){

        medicine[0].m_num = m_num;
        medicine[0].save(function(err){

            if(err)
            {
                console.log(err);

            }
            return callback(1);
        });
    });


}

exports.getMedicineDetail=function(mid,callback)
{

   console.log("mid:"+mid);
    Medicine.find({ mid:mid },function(err,medicine){
        
        //console.log(medicines.length);
        console.log(medicine[0].m_name);
        return callback(err,medicine);

    });


};

exports.removeWish = function(wish_id,callback)
{
    console.log('wish_id'+wish_id);

   

    Wishlist.find({ wish_id: wish_id }).remove(function (err) {
        // Does gone..
        if(err)
        {
            console.log(err);
        }
        return callback(err);
    });


};

exports.addToWishList = function(pid,mid,callback)
{
    console.log(pid);
    console.log(mid);
    var status;
    // Wishlist.count({ mid: mid }, function (err, count) {
    //     console.log(count+"xxxxxxxx");
    //     if(count>0)
    //     {


    //         status = 0;
    //         return callback(status)
    //     }
    //     else{
    //         Wishlist.create({
    //             pid: pid,
    //             mid: mid
    //         }, function(err) {
            
    //             status = 1;
    //             return callback(status);
    //         });
    //     }0
    // });
    Wishlist.find({mid:mid,pid:pid},function(err,wishlist) {
       
        console.log(wishlist);
        if(wishlist.size>0)
        {
            
            status = 0;
            return callback(status)
        }else{
            Wishlist.create({
                            pid: pid,
                            mid: mid
                        }, function(err) {
                        
                            status = 1;
                            return callback(status);
                        });

        }
        


    });



}