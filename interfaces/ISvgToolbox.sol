pragma solidity >=0.8.0;

interface ISvgToolbox {
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
}
