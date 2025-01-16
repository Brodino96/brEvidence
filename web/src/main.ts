// --------------- IMPORTS --------------- \\

import * as THREE from "three"
import { OrbitControls, GLTFLoader } from "three/examples/jsm/Addons.js"

let rendering = false

// --------------- MAIN EVENTS --------------- \\

document.addEventListener("onload", () => {
    //@ts-ignore
    fetch(`https://${GetParentResourceName()}/pageLoaded`, { method: "POST" })
})

window.addEventListener("message", function(event) {
    const data = event.data
    switch (data.action) {
        case "showUI":
            init(data)
            break
        default:
            console.log("event arrived but nothing was specified")
            break
    }
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

function init(data: { model: string; title: string; description: string }) {
    rendering = true
    
    scene.add(ambientLight)
    scene.add(directionalLight)
    
    loader.load(`/models/${data.model}`, (gltf) => {
        scene.add(gltf.scene)
        
    }, undefined, (error) => {
        console.error(error)
    })

    animate()

    document.getElementById("title")!.innerHTML = data.title
    document.getElementById("description")!.innerHTML = data.description

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
        document.body.style.display = "none"
        for (let i = 0; i < scene.children.length; i++) {
            scene.remove(scene.children[i])
        }
        rendering = false
    })
}

setTimeout(() => {
    init({
        model: "skull_downloadable.glb",
        title: "This is a title",
        description: ( "This is a generic\ndescription for the 3d model on my left This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model This is a generic description for this 3d model ")
    })
}, 0)

// --------------- HANDLING BUTTONS --------------- \\

document.getElementById("close_button")?.addEventListener("click", () => {
    closeUI()
})
