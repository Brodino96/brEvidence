// --------------- IMPORTS --------------- \\

import * as THREE from "three"
import { OrbitControls, GLTFLoader } from "three/examples/jsm/Addons.js"

let rendering = false

// --------------- MAIN EVENTS --------------- \\

window.addEventListener("message", (event) => {
    console.log(JSON.stringify(event.data))
    if (event.data.action == "showUI") { init(event.data) }
})

// --------------- SCENE --------------- \\

const container = document.getElementById("model_container")!
const renderer = new THREE.WebGLRenderer({ antialias: true })
const loader = new GLTFLoader()
const scene = new THREE.Scene()
renderer.setSize(container.clientWidth, container.clientHeight)
renderer.setClearColor(0, 0)
container.appendChild(renderer.domElement)

const camera = new THREE.PerspectiveCamera(20, 1, 0.1, 1000)
camera.position.z = 10

const controls = new OrbitControls(camera, renderer.domElement)
controls.enableDamping = true
controls.dampingFactor = 0.05
controls.rotateSpeed = 0.5
controls.enablePan = false
controls.enableZoom = false

const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
const directionalLight = new THREE.DirectionalLight(0xffffff, 1)
directionalLight.position.set(5, 10, 7.5)
directionalLight.castShadow = false

// Shadows details
// directionalLight.shadow.mapSize.width = 2048
// directionalLight.shadow.mapSize.height = 2048
// directionalLight.shadow.camera.near = 0.5
// directionalLight.shadow.camera.far = 500

// --------------- FUNCTIONS --------------- \\

/*
tags = { "user" },
prop = "prop_laptop_lester",
coords = vec3(-1377.4250, -535.4015, 30.2113),
nui = {
    model = "asus_rog_zephyrus_g14_2024.glb",
    offset = vec3(0, -0.1, 0),
    distance = 2,
    title = "Lester the molester's laptop",
    description = "This laptop appears to be covered in some strange white substance, it smells funny",
},
*/

interface configData {
    model: string;
    offset: { x: number; y: number; z: number };
    distance: number;
    title: string;
    description: string;
}
function init(data: configData) {
    rendering = true
    
    scene.add(ambientLight)
    scene.add(directionalLight)
    
    loader.load(`./models/${data.model}`, (gltf) => {
        let model = scene.add(gltf.scene)
        model.position.x = data.offset.x
        model.position.y = data.offset.y
        model.position.z = data.offset.z
    }, undefined, (error) => {
        console.error(error)
    })

    camera.position.z = data.distance
    camera.updateProjectionMatrix()

    animate()

    const title = document.getElementById("title")!
    const desc = document.getElementById("description")!
    title.innerHTML = data.title
    title.title = data.title
    desc.innerHTML = data.description

    document.body.style.visibility = "visible"
}

function animate() {
    if (!rendering) {
        return
    }
    controls.update()
    renderer.render(scene, camera)
    requestAnimationFrame(animate)
}

function closeUI() {
    //@ts-ignore
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: "POST" }).then(() => {
        document.body.style.visibility = "hidden"
        for (let i = 0; i < scene.children.length; i++) {
            scene.remove(scene.children[i])
        }
        rendering = false
    })
}
const testData: configData = {
    model: "asus_rog_zephyrus_g14_2024.glb",
    offset: { x: 0, y: -0.1, z: 0 },
    distance: 2,
    title: "Laptop di Lester the Molester aaaaaaaaaaaaaaaaaaaaaaaaaa dknnawwldkawdlkam òdma wmdòaòwm òda",
    description: "Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra"
}

setTimeout(() => {
    init(testData)
}, 0)

// --------------- HANDLING BUTTONS --------------- \\

document.getElementById("close_button")?.addEventListener("click", () => {
    closeUI()
})
