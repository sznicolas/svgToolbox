# svgToolbox

This toolbox aims to simplify the onchain SVG images.  
Instead of writing many times and in many contracts all the SVG code, use instead: 
```solidity
    // produces a red rectangle in a svg
    return abi.encodedPacked(
                svgContract.startSvg(0, 0,155,100),
                svgContract.styleColor("#i1", hex"ff0000ff"),
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

Deployed [here](https://polygonscan.com/address/0xe7f466a2ce49d02d23a99ea148b0c4233a9ce0b0#code)

For now you can view the [Prototype](https://github.com/sznicolas/protoSvgLib)

Exemple of NFT using this tollbox [here](https://polygonscan.com/address/0x8c356d86ba1b80578626abe4d7cbbeeae031637e#code) and on [OpenSea](https://opensea.io/collection/sundowner) (Right click on the image, then open in a new tab to have an animation on hover)
