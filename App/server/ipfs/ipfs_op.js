const ipfsclient = require('ipfs-http-client');
const CID = require('cids')
const { globSource } = ipfsclient;
const ipfs =  ipfsclient({host:'localhost',port:'5001',protocol:'http'});


//上传指定的文件，并拿到hash值
exports.addfile = async (filepath)=>{
    let filehash = null;
    console.log(`----start read the file path ----`);
    for await (const file of ipfs.add(globSource(filepath, { recursive: true }))) {
        console.log(file);
        console.log(`path is ${file.path}`);
        filehash = new CID(file.cid).toString();
        console.log(`文件hash是${filehash}`);
    }
    console.log(`----end read file----`);
    return filehash;
}
