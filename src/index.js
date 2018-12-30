import "./css/main.scss";
import $ from "jquery";
import Popper from "popper.js";
import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";

import "./prism";

$.expr[':'].external = function(obj){
    return !obj.href.match(/^mailto\:/)
        && (obj.hostname !== location.hostname)
        && !obj.href.match(/^javascript\:/)
        && !obj.href.match(/^$/)
};

$(document).ready(() => {
    $("a:external").attr("target", "_blank");
});

export default { $, Popper };
