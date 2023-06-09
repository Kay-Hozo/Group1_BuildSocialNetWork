pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SocialNetwork is ERC20{
    string private _name;
    string private _symbol;
    
    uint public postCount = 0;
    mapping(uint => Post) public posts;
    mapping(address => mapping(uint => bool)) public addressVotes;
    struct Post{
        uint id;
        string content;
        uint tipAmount;
        uint vote;
        address payable author;
    }

    event PostCreate(
        uint id,
        string content,
        uint tipAmount,
        uint vote,
        address payable author
    );

    event PostTipped(
        uint id,
        string content,
        uint tipAmount,
        uint vote,
        address payable author
    );

    event Vote(
        uint id,
        address authorPost,
        address voter
    );
    constructor()ERC20("SocialNetwork", "SCC") public{
        _name = "SocialNetwork";
        _symbol = "SCC";
    }
    

    function createPost(string memory _content) public{
        // require valid content
        require(bytes(_content).length > 0);// if true continue excution 
        // Increment post
        postCount++;
        // create the post
        address payable payable_addr = payable(msg.sender);
        posts[postCount] = Post(postCount, _content, 0, 0, payable_addr);
        // Trigger event
        emit PostCreate(postCount, _content, 0, 0, payable_addr);
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
        emit PostTipped(postCount, _post.content, _post.tipAmount,_post.vote, _author);
    }

    function votePost(uint _id) public{
        require(_id > 0 && _id <= postCount);
        address payable voter = payable(msg.sender); 
        require(addressVotes[voter][_id] == false);
        Post memory _post = posts[_id];

        _post.vote = _post.vote + 1;
        
        posts[_id] = _post;
        addressVotes[voter][_id] = true;

        emit Vote(_post.id,_post.author, voter);
    }

    

}