import * as THREE from "three"
import { OrbitControls, GLTFLoader } from "three/examples/jsm/Addons.js"
import { Marked } from "@ts-stack/markdown"

interface configData {
    model: string;
    offset: { x: number; y: number; z: number };
    distance: number;
    title: string;
    description: string;
}

class Main {
    
    body: HTMLElement
    rendering: boolean
    container: HTMLElement
    renderer: THREE.WebGLRenderer
    loader: GLTFLoader
    scene: THREE.Scene
    camera: THREE.PerspectiveCamera
    controls: OrbitControls
    ambientLight: THREE.AmbientLight
    directionalLight: THREE.DirectionalLight
    
    constructor() {
        this.body = document.body
        this.rendering = false
        this.container = document.getElementById("modelSpace")!
        this.renderer = new THREE.WebGLRenderer({ antialias: true })
        this.loader = new GLTFLoader()
        this.scene = new THREE.Scene()
        this.camera = new THREE.PerspectiveCamera(20, 1, 0.1, 1000)
        this.controls = new OrbitControls(this.camera, this.renderer.domElement)
        this.ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
        this.directionalLight = new THREE.DirectionalLight(0xffffff, 1)

        window.addEventListener("resize", ()=>{
            this.camera.aspect = this.container.clientWidth / this.container.clientHeight;
            this.camera.updateProjectionMatrix();
            this.renderer.setSize(this.container.clientWidth, this.container.clientHeight, false);
        })
       
        this.renderer.setSize(this.container.clientWidth, this.container.clientHeight)
        this.renderer.setClearColor(0, 0)
        this.container.appendChild(this.renderer.domElement)

        this.camera.position.z = 10 // default camera pos

        this.controls.enableDamping = true
        this.controls.dampingFactor = 0.05
        this.controls.rotateSpeed = 0.5
        this.controls.enablePan = false
        this.controls.enableZoom = true

        this.directionalLight.position.set(5, 10, 7.5)
        this.directionalLight.castShadow = false

        document.getElementById("close_button")?.addEventListener("click", () => {
            this.closeInterface()
        })
    }

    animate = () => {
        if (!this.rendering) {
            return
        }
        this.controls.update()
        this.renderer.render(this.scene, this.camera)
        requestAnimationFrame(this.animate)
    }

    init = (data: configData) => {
        this.rendering = true
    
        this.scene.add(this.ambientLight)
        this.scene.add(this.directionalLight)
        
        this.loader.load(`./models/${data.model}`, (gltf) => {
            let model = this.scene.add(gltf.scene)
            model.position.x = data.offset.x
            model.position.y = data.offset.y
            model.position.z = data.offset.z
        }, undefined, (error) => {
            console.error(error)
        })
    
        this.camera.position.z = data.distance
        this.camera.updateProjectionMatrix()
    
        this.animate()
    
        const title = document.getElementById("title")!
        const desc = document.getElementById("description")!
        title.innerHTML = data.title
        title.title = data.title
        desc.innerHTML = Marked.parse(data.description)
    
        document.body.style.visibility = "visible"
    }

    closeInterface = () => {
        //@ts-ignore
        fetch(`https://${GetParentResourceName()}/closeInterface`, { method: "POST" }).then(() => {
            this.body.style.visibility = "hidden"
            for (let i = 0; i < this.scene.children.length; i++) {
                this.scene.remove(this.scene.children[i])
            }
            this.rendering = false
        }).catch(() => {
            this.closeInterface()
        })
    }
}

const main = new Main()

window.addEventListener("message", (event) => {
    if (event.data.action == "showInterface") { main.init(event.data) } 
})

setTimeout(() => {
    main.init({
        model: "asus_rog_zephyrus_g14_2024.glb",
        offset: { x: 0, y: -0.1, z: 0 },
        distance: 2,
        title: "Laptop di Lester the Molester",
        description: " Questo **portatile** ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo **portatile** ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo **portatile** ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra Questo portatile ha un non so che di strano, sembra essere coperta da una sostanza appiccicosa biancastra"
    })
}, 0)