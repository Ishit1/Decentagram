// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract Decentragram {
  string public name = "Decentragram";

  // storing images
  uint public imageCount=0;
  struct image{
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }
  event imageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
  event imageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  mapping(uint=> image) public images;
  
  //create images
  function uploadimage(string memory _imgHash,string memory _description) public payable {
    require(bytes(_imgHash).length > 0);
    require(msg.sender!=address(0x0));
    address addr=msg.sender;
    address payable wallet=payable(addr);
    imageCount=imageCount+1;

    images[imageCount]=image(imageCount,_imgHash,_description,0,wallet);

    emit imageCreated(imageCount,_imgHash,_description,0,wallet);
  }
  
  //tip images
  function tipImageOwner(uint _id) public payable{
    require(_id>0 && _id<=imageCount);

    image memory _image=images[_id];
    address payable _author=_image.author;

    (_author).transfer(msg.value); 
    _image.tipAmount= _image.tipAmount+msg.value;
    images[_id]=_image;

    emit imageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
}
