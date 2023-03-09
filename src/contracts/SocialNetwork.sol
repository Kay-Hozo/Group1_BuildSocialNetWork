pragma solidity >=0.4.22 <0.9.0;

contract SocialNetwork{
    string public name;
    uint public postCount = 0;
    mapping(uint => Post) public posts;

    struct Post{
        uint id;
        string content;
        uint tipAmount;
        address payable author;
    }

    event PostCreate(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    event PostTipped(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    constructor() public {
        name = "Dapp University Social Network";
    }

    function createPost(string memory _content) public{
        // require valid content
        require(bytes(_content).length > 0);// if true continue excution 
        // Increment post
        postCount++;
        // create the post
        address payable payable_addr = payable(msg.sender);
        posts[postCount] = Post(postCount, _content, 0, payable_addr);
        // Trigger event
        emit PostCreate(postCount, _content, 0, payable_addr);
    }

    function tipPost(uint _id) public payable {
        // make sure the id is valid
        require(_id > 0 && _id <= postCount);
        // fetch the post
        Post memory _post = posts[_id];
        // fetch the author
        address payable _author = _post.author;
        address payable payable_addr = payable(_author);
        // pay the author by sending them Ether
        payable_addr.transfer(msg.value); // send and transfer just Object address payable not address
        // Incremet the tip amount
        _post.tipAmount = _post.tipAmount + msg.value;
        // update the post
        posts[_id] = _post;
        // trigger event
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
    }

}