const express = require('express');
const model = require('../Model/modelPost');
const router = express.Router()
//Post Method
router.post('/uploadPost', async(req, res) => {
    const data = new model ({
     title : req.body.title,    
     author :  req.body.author,
     description :  req.body.description,
     image :  req.body.image,
     video :  req.body.video,
     likes :  req.body.likes,
     dislikes :  req.body.dislikes,
    numberOfComments: req.body.numberOfComments,
     comments: req.body.comments
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
router.get('/getAllPosts', async(req, res) => {
    try{
        const data = await model.find();
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

//Get by ID Method
router.get('/getPostById/:id', async(req, res) => {
    try{
        const data = await model.findById(req.params.id);
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})
router.get('/getPostByUserName/:userName',async(req,res)=>{
    try{
        const response = await model.find({"author.username":req.params.userName});
        res.status(200).json(response);
    }catch(err){
        res.status(404).json({message: err.message});
    }
})


//Update by ID Method
router.patch('/updatePostById/:id', async(req, res) => {
   try{
    const id = req.params.id;
    const updatedData =  req.body;
    const options = {new : true};
        const result = await model.findByIdAndUpdate(id,updatedData,options)
        res.status(200).send(result);
   }catch (error) {
        res.status(400).json({message: error.message})
    }
})

//Delete by ID Method
router.delete('/deletePostById/:id', async(req, res) => {
    try{
    const id = req.params.id;
    const data = await model.findByIdAndDelete(id);
    res.status(200).send('Document with ${data.name} has been deleted');
    }catch (error) {
        res.status(400).json({message: error.message})
    }

})

module.exports = router;