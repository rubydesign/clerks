//= require three.js
//= require STLExporter.js
//= require OrbitControls.js
//= require vue
//= require range_slider

THREE.Cache.enabled = true;
let camera, scene, renderer , materials;
// group is where the mesh is added to
let group, main_mesh;

function init() {
  // CAMERA
  camera = new THREE.PerspectiveCamera( 30, window.innerWidth / window.innerHeight, 1, 1500 );
  camera.position.set( 0, 700, 700 );

  // SCENE
  scene = new THREE.Scene();
  scene.background = new THREE.Color( 0x000000 );

  // LIGHTS
  const light = new THREE.AmbientLight( 0x404040 , 1.5); // soft white light
  scene.add( light );
  const pointLight = new THREE.PointLight( 0x404040, 1.5 );
  pointLight.position.set( 0, 100, 90 );
  scene.add( pointLight );

  materials = [
    new THREE.MeshPhongMaterial( { color: 0xffffff, flatShading: true } ), // front
    new THREE.MeshPhongMaterial( { color: 0xffffff } ) // side
  ];

  group = new THREE.Group();
  group.position.y = 50;
  scene.add( group );

  // RENDERER
  renderer = new THREE.WebGLRenderer( { canvas: document.getElementById( "viewer" ) } );
  renderer.setPixelRatio( window.devicePixelRatio );
  renderer.setSize( window.innerWidth , window.innerHeight );

  const controls = new THREE.OrbitControls( camera, renderer.domElement );

  controls.maxPolarAngle = Math.PI * 0.5;
  controls.minDistance = 100;
  controls.maxDistance = 50000;

  window.addEventListener( 'resize', onWindowResize, false );

}

function onWindowResize() {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize( window.innerWidth, window.innerHeight );
}


function animate() {
  requestAnimationFrame( animate );
  render();
}

function render() {
  renderer.clear();
  renderer.render( scene, camera );
}

function exportBinary() {
  exporter = new STLExporter();
  buffer = exporter.parse( main_mesh, { binary: true } );
  blob = new Blob( [ buffer ], { type: 'application/octet-stream' } );
  const link = document.createElement( 'a' );
  link.style.display = 'none';
  document.body.appendChild( link );
  link.href = URL.createObjectURL( blob );
  link.download = 'numbers.stl';
  link.click();
}

buttonExportBinary = document.getElementById( 'exportBinary' );
buttonExportBinary.addEventListener( 'click', exportBinary );
