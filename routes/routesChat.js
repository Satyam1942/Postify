const express = require('express');
const model = require('../Model/modelChat');
const router = express.Router()


//Post Method
router.post('/uploadMessage', async(req, res) => {
    const data = new model ({
     friendName : req.body.friendName,
     from: req.body.from,
     messageBody : req.body.messageBody,
     messageImage: req.body.messageImage,
     messageInfo : req.body.messageInfo
     })
    try {
        const dataToSave = await data.save();
        res.status(200).json(dataToSave)
    }
    catch (error) {
        res.status(400).json({message: error.message})
    }
})

//Get all Method
router.get('/getAllMessages', async(req, res) => {
    try{
        const data = await model.find();
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

router.get('/search/:fromId/:toId',async(req,res)=>{
try{
          const response = await model.find({from:req.params.fromId, friendName:req.params.toId});
        res.status(200).json(response);
}catch(err){
    res.status(404).json({message: err.message})
}
})

router.get('/search/:toId',async(req,res)=>{
    try{
              const response = await model.find({friendName:req.params.toId});
            res.status(200).json(response);
    }catch(err){
        res.status(404).json({message: err.message})
    }
    })
//Get by ID Method
// router.get('/getChatById/:id', async(req, res) => {
//     try{
//         const data = await model.findById(req.params.id);
//         res.json(data)
//     }
//     catch(error){
//         res.status(500).json({message: error.message})
//     }
// })

//Update by ID Method
// router.patch('/updatePostById/:id', async(req, res) => {
//    try{
//     const id = req.params.id;
//     const updatedData =  req.body;
//     const options = {new : true};
//         const result = await model.findByIdAndUpdate(id,updatedData,options)
//         res.send(result);
//    }catch (error) {
//         res.status(400).json({message: error.message})
//     }
// })

//Delete by ID Method
router.delete('/deleteMessageById/:id', async(req, res) => {
    try{
    const id = req.params.id;
    const data = await model.findByIdAndDelete(id);
    res.send('Document with ${data.name} has been deleted');
    }catch (error) {
        res.status(400).json({message: error.message})
    }

})

module.exports = router;