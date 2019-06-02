import React from 'react';

import './App.css';
import { Button, List } from 'antd-mobile';
import { Flex, WhiteSpace } from 'antd-mobile';
import Zdog from 'zdog';
const PlaceHolder = ({ className = '', ...restProps }) => (
    <div className={`${className} placeholder`} {...restProps}>Block</div>
);
let isSpinning = true;

let illo = new Zdog.Illustration({
    element: '.zdog-canvas',
    zoom: 4,
    dragRotate: true,
    // stop spinning when drag starts
    onDragStart: function() {
        isSpinning = false;
    },
});

// circle
new Zdog.Ellipse({
    addTo: illo,
    diameter: 20,
    translate: { z: 10 },
    stroke: 5,
    color: '#636',
});

// square
new Zdog.Rect({
    addTo: illo,
    width: 20,
    height: 20,
    translate: { z: -10 },
    stroke: 3,
    color: '#E62',
    fill: true,
});

function animate() {
    illo.rotate.y += isSpinning ? 0.03 : 0;
    illo.updateRenderGraph();
    requestAnimationFrame( animate );
}

const FlexExample = () => (

    <div className="flex-container">
      <div className="sub-title">Basic</div>
      <Flex>
        <Flex.Item><PlaceHolder /></Flex.Item>
        <Flex.Item>
            <canvas className="zdog-canvas" width="240" height="240"></canvas></Flex.Item>
      </Flex>
      <WhiteSpace size="lg" />
      <Flex>
        <Flex.Item><PlaceHolder /></Flex.Item>
        <Flex.Item><PlaceHolder /></Flex.Item>
        <Flex.Item><PlaceHolder /></Flex.Item>
      </Flex>
      <WhiteSpace size="lg" />
      <Flex>
        <Flex.Item><PlaceHolder /></Flex.Item>
        <Flex.Item><PlaceHolder /></Flex.Item>
        <Flex.Item><PlaceHolder /></Flex.Item>
        <Flex.Item><PlaceHolder /></Flex.Item>
      </Flex>
      <WhiteSpace size="lg" />

      <div className="sub-title">Wrap</div>
      <Flex wrap="wrap">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
      </Flex>
      <WhiteSpace size="lg" />

      <div className="sub-title">Align</div>
      <Flex justify="center">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
      </Flex>
      <WhiteSpace />
      <Flex justify="end">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
      </Flex>
      <WhiteSpace />
      <Flex justify="between">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline" />
      </Flex>

      <WhiteSpace />
      <Flex align="start">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline small" />
        <PlaceHolder className="inline" />
      </Flex>
      <WhiteSpace />
      <Flex align="end">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline small" />
        <PlaceHolder className="inline" />
      </Flex>
      <WhiteSpace />
      <Flex align="baseline">
        <PlaceHolder className="inline" />
        <PlaceHolder className="inline small" />
        <PlaceHolder className="inline" />
      </Flex>
    </div>
);

function App() {
    animate();
  return (
      <div className="App">


          <FlexExample />



    </div>
  );
}

export default App;
