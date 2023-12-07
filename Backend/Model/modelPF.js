const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String
    },
    age: {
        required: true,
        type: Number
    },
    gender:{
        required:true,
        type: String
    },
    username:{
        required:true,
        type: String,
        unique: true
    },
    password:{
        required:true,
        type: String
    },
    contact:{
        required:true,
        type: {
            PhNo:{
                required:false,
                type: String
            },
            Email:{
                required: true,
                type:String
            }
        }
    },
    DP:{
        required:false,      
        type: String
    },
    friends:{
        required:true,
        type: Array
    },
    friendRequestSent:{
        required:true,
        type:Array
    },
    friendRequestRecieved:{
        required:true,
        type:Array
    },
    followers:{
        required:true,
        type: Array
    },
    following:{
        required:true,
        type: Array
    }
})

 
module.exports = mongoose.model('PersonalInfo', dataSchema)