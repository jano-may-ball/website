/*
 * Jano Ticketing website
 * Copyright (C) 2018-2019 Andrew Ying and other contributors.
 *
 * This file is part of Jano Ticketing website.
 *
 * Jano Ticketing website is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License
 * v3.0 supplemented by additional permissions and terms as published at
 * COPYING.md.
 *
 * Jano Ticketing website is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */

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

$(document).ready(function() {
    $("a:external").attr("target", "_blank");
});

export default { $, Popper };
