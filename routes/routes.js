const express = require('express');
const model = require('../Model/modelPF');
const router = express.Router()
var bcrypt = require('bcrypt');
//Post Method
router.post('/addUser', async(req, res) => {
    const data = new model ({
     name : req.body.name,
     age :  req.body.age,
     gender :  req.body.gender,
     username :  req.body.username,
     password :  generateHash(req.body.password),
     contact :  req.body.contact,
     DP :  req.body.DP,
     friends :  req.body.friends,
     friendRequestSent: req.body.friendRequestSent,
     friendRequestRecieved: req.body.friendRequestRecieved,
     followers: req.body.followers,
     following: req.body.following
        })
     
    try {
        const oldUser = await model.findOne({data});
          
        if(oldUser) return res.status(409).send("User Already Exist. Please Login");
        else{
            const dataToSave = await data.save();
        res.status(200).json(dataToSave)
        }
    }
    catch (error) {
        res.status(400).json({message: error.message})
    }
})
//login
router.post('/login',async(req,res)=>{
    try{
        const {username,password} = req.body;
        if(!(username && password)) {res.status(400).send("Enter All Details");}
        else{
        const user = await model.findOne({username});
        if(user && (await bcrypt.compare(password,user.password)))
        res.status(200).json(user);
        else res.status(400).send("Invalid Credentials");
        }
    }catch(error) {
        res.status(400).json({message: error.message})
    }
});


//Get all Method
router.get('/getAllUsers', async(req, res) => {
    try{
        const data = await model.find();
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

//Get by ID Method
router.get('/getUserById/:id', async(req, res) => {
    try{
        const data = await model.findById(req.params.id);
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

router.get('/search/:searchKey',async(req,res)=>{
    try{
        const response = await model.find({$or :[{name: req.params.searchKey},{username: req.params.searchKey}]});
        res.status(200).json(response);
    }catch(err){
        res.status(404).json({message: err.message});
    }
})

//Update by ID Method
router.patch('/updateUserById/:id', async(req, res) => {
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
router.patch('/updateUserPasswordById/:id', async(req, res) => {
    try{
     const id = req.params.id;
     const updatedData =  generateHash(req.body);
     const options = {new : true};
         const result = await model.findByIdAndUpdate(id,updatedData,options)
         res.status(200).send(result);
    }catch (error) {
         res.status(400).json({message: error.message})
     }
 })
//Delete by ID Method
router.delete('/deleteUserById/:id', async(req, res) => {
    try{
    const id = req.params.id;
    const data = await model.findByIdAndDelete(id);
    res.status(200).send('Document with ${data.name} has been deleted');
    }catch (error) {
        res.status(400).json({message: error.message})
    }

})
function generateHash(password)
{
    const salt = bcrypt.genSaltSync(8);
    const hash = bcrypt.hashSync(password,salt);
    return hash
}
module.exports = router;