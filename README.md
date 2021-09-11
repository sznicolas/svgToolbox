# svgToolbox

This toolbox aims to simplify, unify and reduce gas costs for the onchain SVG images.  
Instead of writing many times and in many contracts all the SVG code, use instead: 
```solidity
    // produces a red rectangle in a complete svg format
    return abi.encodedPacked(
                svgContract.startSvg(0, 0,155,100),
                //fills #i1 in red:
                svgContract.styleColor("#i1", hex"ff0000ff"),
                // rectangle id=i1 class=c1 ending tag/ starts at 0,0 to 10,10:
                svgContract.rect(hex"01010100000a0a"),
                svgContract.endSvg()
    );

//Output (re-indented):
<svg viewBox='0 0 155 100' xmlns='http://www.w3.org/2000/svg'>
    <style>
        #i1{
            fill: rgba(255,0,0,255);
        }
    </style>
    <rect id='i1' class='c1'  x='0' y='0' width='10' height='10' />
</svg>
```
As you can see, most of the parameters are encoded, so the gas cost for the storage is limited.  
The most impressive data reduction is visible in `<path` data, which draws advanced shapes [example here](https://github.com/sznicolas/svgToolbox/blob/149d090eeaf498dc74580aa01576b792a0bd10f7/contracts/sundownerERC721.sol#L33) produces [this](https://opensea.io/assets/matic/0x8c356d86ba1b80578626abe4d7cbbeeae031637e/19)


Functions implemented yet:
```
function startSvg(uint _x, uint _y, uint _length, uint _width) external view returns (bytes memory);
function endSvg() external view returns (bytes memory);
function styleColor(bytes memory _element, bytes memory _b ) external view returns (bytes memory);
function ellipse(bytes memory _b) external view returns (bytes memory);
function path(bytes memory _b, string memory _path) external view returns (bytes memory);
function circle(bytes memory _b) external view returns (bytes memory);
function polyline(bytes memory _b) external view returns (bytes memory);
function rect(bytes memory _b) external view returns (bytes memory);
function polygon(bytes memory _b) external view returns (bytes memory);
function path(bytes memory _b) external view returns (bytes memory);
function use(bytes memory _b) external view returns (bytes memory);
function linearGradient(bytes memory _b) external pure returns (bytes memory);
```
All the parameters are unified for the shapes, let's see `polygon`for example:
Parameters:
| Pos    | Ex. Value | Meaning       | Note                |
|-------:|-----------|---------------|---------------------|
| 0      | fa        | id="i250"     | Use 00 to disable   |
| 1      | fe        | class="c254"  |                     |
| 2      | 01        | ending '>'    | if 0 ends with '/>' | 
| 3,4    | 404e      | 1st point, xy |                     |
| 5,6    | 4000      | 2nd point, xy |                     |
| 7,8    | 006a      | 3rd point, xy |                     |
| m,n... |           | nth point, xy |                     |

# Tools
## tokenURItoSVG.py
[tokenURItoSVG](scripts/tokenURItoSVG) displays metadata, svg and formatted svg when debbuging in Brownie.
## svgpath2hex.py
[svgpath2hex.py](scripts/svgpath2hex.py) tries to round a `path data` and codes it in a bytes string readable by [path](https://github.com/sznicolas/svgToolbox/blob/149d090eeaf498dc74580aa01576b792a0bd10f7/contracts/svgtoolbox.sol#L184)

Deployed [here](https://polygonscan.com/address/0xe7f466a2ce49d02d23a99ea148b0c4233a9ce0b0#code)

For now you can view the [Prototype](https://github.com/sznicolas/protoSvgLib)

Exemple of NFT using this tollbox [here](https://polygonscan.com/address/0x8c356d86ba1b80578626abe4d7cbbeeae031637e#code) and on [OpenSea](https://opensea.io/collection/sundowner) (Right click on the image, then open in a new tab to have an animation on hover)
