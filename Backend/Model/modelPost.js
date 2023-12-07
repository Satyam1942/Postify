const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    title: {
        required: true,
        type: String
    },
    author:{
        required: true,
        type: {
            username:{
                required: true,
                type: String
            },
            DP:
            {
                required: true,
                type: String  
            }
        }
    },
    description: {
        required: false,
        type: String
    },
    image:{
        required:false,
        type: String
    },
    video:{
        required:false,
        type: String
    },
    likes:{
        required:true,
        type: Number
    },
    dislikes:{
        required:true,
        type: Number
    },
    numberOfComments:{
        required:true,
        type: Number 
    },
    comments:{
        required:false,      
        type: [
          { username:{
            required: false,
            type: String
           },
           body:{
            required: false,
            type: String
           }
        }
        ]
        
    }
    
   
})

module.exports = mongoose.model('PostData', dataSchema)