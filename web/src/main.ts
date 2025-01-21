import { WebGLRenderer, Scene, PerspectiveCamera, AmbientLight, DirectionalLight } from "three"
import { OrbitControls, GLTFLoader } from "three/examples/jsm/Addons.js"
import { Marked } from "@ts-stack/markdown"

interface configData {
    model: string|null;
    offset: { x: number|null; y: number|null; z: number|null };
    distance: number|null;
    title: string|null;
    description: string|null;
}

const placeholder = {
    model: "skull_downloadable.glb",
    offset: { x: 0, y: 0, z: 0 },
    distance: 10,
    title: "This is a title",
    description: "This is a description",
}

class Main {
    
    body: HTMLElement
    rendering: boolean
    container: HTMLElement
    renderer: WebGLRenderer
    loader: GLTFLoader
    scene: Scene
    camera: PerspectiveCamera
    controls: OrbitControls
    ambientLight: AmbientLight
    directionalLight: DirectionalLight

    defaultCameraPosition: number
    
    constructor() {
        this.body = document.body
        this.rendering = false
        this.container = document.getElementById("model")!
        this.renderer = new WebGLRenderer({ antialias: true })
        this.loader = new GLTFLoader()
        this.scene = new Scene()
        this.camera = new PerspectiveCamera(20, 1, 0.1, 1000)
        this.controls = new OrbitControls(this.camera, this.renderer.domElement)
        this.ambientLight = new AmbientLight(0xffffff, 0.5)
        this.directionalLight = new DirectionalLight(0xffffff, 1)

        this.renderer.setSize(this.container.offsetWidth, this.container.offsetHeight)
        this.renderer.setClearColor(0, 0)
        this.container.appendChild(this.renderer.domElement)

        this.defaultCameraPosition = 10 // default camera pos

        this.controls.enableDamping = true
        this.controls.dampingFactor = 0.05
        this.controls.rotateSpeed = 0.5
        this.controls.enablePan = false
        this.controls.enableZoom = false

        this.directionalLight.position.set(5, 10, 7.5)
        this.directionalLight.castShadow = false

        document.getElementById("close")?.addEventListener("click", () => {
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
        
        let modelToLoad: string = data.model ?? placeholder.model
        this.loader.load(`./models/${modelToLoad}`, (gltf) => {
            let model = this.scene.add(gltf.scene)
                model.position.x = data.offset.x ?? placeholder.offset.x
                model.position.y = data.offset.y ?? placeholder.offset.y
                model.position.z = data.offset.z ?? placeholder.offset.z
        }, undefined, (error) => {
            console.error(error)
        })

        this.camera.position.z = data.distance ?? placeholder.distance
        this.camera.updateProjectionMatrix()
        this.animate()
    
        const title = document.getElementById("title")!
        const desc = document.getElementById("description")!
        title.innerHTML = data.title ?? placeholder.title
        title.title = data.title ?? placeholder.title
        if (data.description) {
            desc.innerHTML = Marked.parse(data.description)
        } else {
            desc.innerHTML = placeholder.description
        }
    
        this.body.style.visibility = "visible"
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
    if (event.data.action == "showInterface") { main.init(event.data.payload) } 
})

// setTimeout(() => {
//     main.init({
//         model: "asus_rog_zephyrus_g14_2024.glb",
//         offset: { x: 0, y: -0.1, z: 0 },
//         distance: 1.5,
//         title: "Laptop di Lester the Molester",
//         description: "Questo laptop sembrerebbe appartenere ad un certo **Lester**, non sappiamo molto su di lui ma a quanto pare ha aiutato la __banda__ a fuggire dal penitenziario.",
//     })
// }, 0)