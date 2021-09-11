// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ISvgToolbox.sol";
import "./Base64.sol";

contract Sundowner is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable {
    ISvgToolbox svgContract;
    using Counters for Counters.Counter;
    using Strings for uint256;

    uint256 constant maxSupply = 10000; // The last could mint little bit more ;-)
    uint256 constant price = 10000000000 gwei; //10 MATIC
//    uint256 constant price = 10000000 gwei; //0.01 MATIC
    Counters.Counter private _tokenIdCounter;

    // Define svg scene
    // circle id=i1 class=c1 ending tag/ at 150,10 radius 15
    bytes constant sun = hex"010101960a0f"; 
    bytes constant suncolor = hex"f22800ff";
    // rectangle id=i2 class=c2 ending tag/ 0 0 155 100
    bytes constant rectBg = hex"02020100009b64";
    //bytes constant bgcolor = hex"ffeecccc";
    // linearGradient id=i5 x1=0 y1=0 x2=0 y2=1 (offset 0% color , 40% .., 100% ...)
    bytes constant bgGradient = hex"050000000100f9e9c9dd28ffeeccdd64ccbb9999";
    //path data defining rekt frogg
    bytes constant rektLogo = hex"0303014d2d0b432c0c2a0e280f432212181717174316170e1b0d1d4309210725052d430330023302344300360138033b43063d073e0d4143114313431a4443224424452545432746294629454329452844274443254425432843432a432b432b42432b412940274143244124402740432840293e293e43293e263e233e43203f1c3f1a3e43183e173e173e43163e163d163d43163d1a3c1f3c43263c273c283b432a392a372834432834273326324c28304c2a2e432a302a312a31432a332a352b36432c37303b343d43373e3e40404043413f413e3f3e433c3d3c3d3f3c43423b423b3f3b433c3b3b3a3e3943403840363e37433d373c373c38433b383a38393943373a36393336433336323530334331313130313043322e332c332a43332935253822433d1b3f15401243400e3f0d3a0b43380b360a350943320731072f09432e092d0b2d0b5a";
    // use id i4 class c4 ending tag( xlink:href #i3 pos x 10 y 20
    bytes constant useRektLogo = hex"040401030a14";
    bytes constant description = "Commemorative Token - Use of SvgToolbox, onchain Svg Toolbox";

    // Uses toolbox contract which must be deployed before
    constructor(address _svgContractAddr) ERC721("Sundowner", "SDWN"){
        svgContract = ISvgToolbox(_svgContractAddr);
    }
    
    // Builds the whole SVG
    function svgRaw(uint256 _tokenId) public view returns(bytes memory){
        return abi.encodePacked(
            svgContract.startSvg(0, 0,155,100),
            //svgContract.styleColor("#i2", bgcolor),
            svgContract.styleColor("#i1", suncolor),
            svgContract.linearGradient(bgGradient),
            svgContract.rect(rectBg),
            svgContract.circle(sun),
            getRekt(),
            svgContract.use(useRektLogo),
            "<style>svg:hover .c4{animation:b 4s infinite ease-in-out alternate;",
            "transform-origin: 50px 50px;stroke-linejoin: round;stroke-width:.2;}",
            "@keyframes b{to{transform:scale(-.3,.7);fill:#d226;filter:blur(2px);}}",
            ".c1{ filter:blur(4px);}#i2{fill:url(#i5);}</style>",
            svgContract.endSvg()
        );
    }

    // exportable rekt logo
    function getRekt() public view returns(bytes memory) {
        return abi.encodePacked(
            "<defs>",
            svgContract.path(rektLogo),
            "</defs>"
        );
    }
    // Pack the SVG with the metadata
    function svgBase64(uint256 _tokenId) public view returns(string memory){
        return (
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svgRaw(_tokenId))
                )
            )
        );
    }

    function createToken(uint _qty) external payable {
        require(maxSupply > _tokenIdCounter.current(), "No more Token to mint");
        // So we could have 19 more than the total supply :
        require(_qty > 0 && _qty <= 200, "mint qty must be between 1-20");
        require(_qty * price == msg.value, "Matic amount is not correct");
        for (uint i = 0; i < _qty; i++){
            _safeMint(msg.sender, _tokenIdCounter.current());
            _tokenIdCounter.increment();
        }
    }

    // The following functions are overrides required by Solidity.

    function withdraw() public onlyOwner {
		(bool success, ) = msg.sender.call{value: address(this).balance}('');
		require(success, "Withdrawal failed");
    }
    receive() external payable {}
    
    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return string(abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(bytes(
                    abi.encodePacked(
                        '{"name":"',
                        name(),
                        '", "image": "',
                        svgBase64(tokenId),
                        '"}'
                    )
                )) 
        ));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
