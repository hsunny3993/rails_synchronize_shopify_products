import { Application } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"
import jquery from "jquery"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application
window.jQuery = jquery
window.$ = jquery

export { application }
