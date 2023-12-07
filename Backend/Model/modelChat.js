const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    friendName: {
        required: true,
        type: String
    },
    from: {
        required: true,
        type: String
    },
    messageBody:{
        required: true,
        type: String
    },
    messageImage: {
            required:false,
            type:String
    },
   
    messageInfo:{
        required: true,
        type: {
            date:{
                required: true,
                type: String
            },
            time:
            {
                required: true,
                type: String
            },
            timeStamp:{
                required:true,
                type: Number
            }
        
        }
    }
    
   
})

module.exports = mongoose.model('ChatData', dataSchema)