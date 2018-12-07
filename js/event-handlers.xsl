<?xml version="1.0"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	
	<xsl:template name="add-event-handlers">
		<xsl:element name="script">
			<xsl:attribute name="type">text/javascript</xsl:attribute>
			<xsl:text disable-output-escaping="yes">
				/* EVENT HANDLERS */
				
				var clickAddButton = function(button) {
					var newNode = button.previousElementSibling.cloneNode(true);
					
					newNode.removeAttribute("hidden");
					
					newNode.querySelectorAll("input, select, textarea").forEach(function(o) {
						if (o.closest("[hidden]") == null)
							o.removeAttribute("disabled");
					});
					
					button.parentNode.insertBefore(
						newNode, button.previousElementSibling
					);
					
					if ((button.parentNode.children.length - 2) == button.getAttribute("data-xsd2html2xml-max"))
						button.setAttribute("disabled", "disabled");
				}
				
				var clickRemoveButton = function(button) {
					if ((button.closest("section").children.length - 2) == button.closest("section").lastElementChild.getAttribute("data-xsd2html2xml-min"))
						button.closest("section").lastElementChild.click();
					
					if ((button.closest("section").children.length - 2) == button.closest("section").lastElementChild.getAttribute("data-xsd2html2xml-max"))
						button.closest("section").lastElementChild.removeAttribute("disabled");
					
					button.closest("section").removeChild(
						button.closest("fieldset, label")
					);
				}
				
				var clickRadioInput = function(input, name) {
					document.querySelectorAll("[name=".concat(name).concat("]")).forEach(function(o) {
						o.removeAttribute("checked");
						var section = o.parentElement.nextElementSibling;
						
						section.querySelectorAll("input, select, textarea").forEach(function(p) {
							if (input.parentElement.nextElementSibling.contains(p)) {
								if (p.closest("[data-xsd2html2xml-choice]") === section) {
									if (p.closest("*[hidden]") === null)
										p.removeAttribute("disabled");
									else
										p.setAttribute("disabled", "disabled");
								}
							} else
								p.setAttribute("disabled", "disabled");
						});
					});
					input.setAttribute("checked","checked");
				}
				
				var pickFile = function(input, file, type) {
					var resetFilePicker = function(input) {
						input.removeAttribute("value");
						input.removeAttribute("type");
						input.setAttribute("type", "file");
					}
					
					var fileReader = new FileReader();
					
					fileReader.onloadend = function() {
						if (fileReader.error) {
							alert(fileReader.error);
							resetFilePicker(input);
						} else {
							input.setAttribute("value",
								(type.endsWith(":base64binary"))
								? fileReader.result.substring(fileReader.result.indexOf(",") + 1)
								//convert base64 to base16 (hexBinary)
								: atob(fileReader.result.substring(fileReader.result.indexOf(",") + 1))
							    	.split('')
							    	.map(function (aChar) {
							    		return ('0' + aChar.charCodeAt(0).toString(16)).slice(-2);
							    	})
									.join('')
									.toUpperCase()
							);
						};
					};
					
					if(file) {
						fileReader.readAsDataURL(file);
					} else {
						resetFilePicker(input);
					}
					
					if (input.getAttribute("data-xsd2html2xml-required")) input.setAttribute("required", "required");
				}
			</xsl:text>
		</xsl:element>	
	</xsl:template>
	
</xsl:stylesheet>