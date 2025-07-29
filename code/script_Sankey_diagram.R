#load necessary libraries

library(networkD3)
library(htmlwidgets)
library(webshot)

##Sankey diagram, Figure 3.
# define nodes nb of ASV all along the Sankey + 11 nodes (only one climate zone whaterver we have assigned / non assigned ASV)

nodes <- data.frame(name = c("Total number of environmental sequences of diatoms (3302)",  # 0
                             "Known species name (1905)",         # 1
                             "Unknown species name (1397)",       # 2
                             "Cosmopolitan (897)",                # 3
                             "Endemic (1008)",                    # 4
                             "Cosmopolitan (376)",                # 5
                             "Endemic (1021)",                    # 6
                             "Mediterranean",                     # 7
                             "Equatorial",                        # 8
                             "Nordic",                            # 9
                             "Temperate"                          # 10
))

# Define links with correct flow, now directed to separate climate zone nodes
links <- data.frame(source = c(0, 0,           # From Total ASVs to Assigned and Not Assigned
                               1, 1, 2, 2,     # From Assigned and Not Assigned to Cosmopolitan and Endemic
                               3, 3, 3, 3,     # From Assigned Cosmopolitan to climate zones
                               4, 4, 4, 4,     # From Assigned Endemic to climate zones
                               5, 5, 5, 5,     # From Not Assigned Cosmopolitan to climate zones
                               6, 6, 6, 6),    # From Not Assigned Endemic to climate zones
                    target = c(1, 2,           # Links from Total ASVs to Assigned and Not Assigned
                               3, 4, 5, 6,     # Links from Assigned and Not Assigned to Cosmopolitan and Endemic
                               7, 8, 9, 10,    # Links from Assigned Cosmopolitan to climate zones
                               7, 8, 9, 10,    # Links from Assigned Endemic to climate zones
                               7, 8, 9, 10,    # Links from Not Assigned Cosmopolitan to climate zones
                               7, 8, 9, 10),   # Links from Not Assigned Endemic to climate zones
                    value = c(1905, 1397,          # Total ASVs to Assigned (58%) and Not Assigned (42%)
                              897, 1008, 376, 1021,  # Assigned/Not Assigned split into Cosmopolitan and Endemic
                              # for the next values, given that some ASV could be present in several climate zones (cosmopolite), some proportions were calculated based on the nb of asv
                              290.81, 110.04, 141.47, 353.68,  # Assigned Cosmopolitan to climate zones
                              95.19, 418.83, 266.53, 228.45,   # Assigned Endemic to climate zones
                              117.00, 26.00, 71.50, 162.50,   # Not Assigned Cosmopolitan to climate zones
                              55.89, 670.68, 195.62, 97.81)    # Not Assigned Endemic to climate zones
)

# Define a color scale for the nodes with custom colors for climate zones and other categories
color_scale <- 'd3.scaleOrdinal()
               .domain(["Total number of environmental sequences of diatoms (3302)", 
                        "Known species name (1905)", "Unknown species name (1397)", 
                        "Cosmopolitan (897)", "Endemic (1008)", 
                        "Cosmopolitan (376)", "Endemic (1021)", 
                        "Mediterranean", "Equatorial", "Nordic", "Temperate"])
               .range(["#8c8c8c", "#66c2a5", "#1f78b4",  
                       "#6a3d9a", "#b15928",             
                       "#6a3d9a", "#b15928",             
                       "#FFA500", "#F08080", "#FFFFFF", "#87CEFA"])'

# Create the Sankey diagram with custom colors
sankey <- sankeyNetwork(Links = links, Nodes = nodes, 
                        Source = "source", Target = "target", 
                        Value = "value", NodeID = "name", 
                        units = "ASVs",
                        fontSize = 17,    # Adjust font size
                        nodeWidth = 15,   # Control the width of the nodes
                        nodePadding = 10, # Control the padding between nodes
                        sinksRight = FALSE, # Arrange the flow from left to right
                        colourScale = color_scale # Apply custom color scale
)

# Print the Sankey diagram with color customization
print(sankey)


html_file <- "figure_3.html"
saveNetwork(sankey, file = html_file)

# Use webshot to save the Sankey diagram as a PNG
png_file <- "figure_3.png"
webshot(html_file, png_file, delay = 0.2, cliprect = "viewport")




###Sankey diagram, Figure 7

# Define nodes 

nodes <- data.frame(name = c("36 species", 
                             "Strong link between\nphylogenetic position of ASVs\nand climate zones presence\n(strong phylogenetic signal)", 
                             "Intermediate situation\n(intermediate phylogenetic signal)", 
                             "ASVs are present\nin climate zones\nregardless of their\nphylogenetic position\n(low phylogenetic signal)", 
                             "No phylogenetic signal",
                             "Environmental filtering regularly detected", 
                             "Environmental filtering, more rarely detected",
                             "Overriding importance of stochastic processes,\nenvironmental filtering almost never detected"))

links <- data.frame(source = c(0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4),
                    target = c(1, 2, 3, 4, 5, 6, 7, 5, 6, 7, 5, 6, 7, 7),
                    value = c(33, 22, 42, 3, 22, 8, 3, 11, 8, 3, 6, 14, 25, 3))

color_scale <- 'd3.scaleOrdinal()
                .domain(["36 species", "Strong link between phylogenetic position of ASVs and climate zones presence (strong phylogenetic signal)", "Intermediate situation (intermediate phylogenetic signal)", "ASVs are present in climate zones regardless of their phylogenetic positio (low phylogenetic signal)", 
                         "No phylogenetic signal", "Environmental filtering regularly detected", "Environmental filtering, more rarely detected",
                         "Overriding importance of stochastic processes, environmental filtering almost never detected"])
                .range(["#c2e699", "#66c2a5", "#b15928", "#8da0cb", "#ff6347", "#4169e1", "#ffa500", "#ff0000"])'

sankey3 <- sankeyNetwork(Links = links, Nodes = nodes, 
                         Source = "source", Target = "target", 
                         Value = "value", NodeID = "name", 
                         units = "Flow",
                         fontSize = 17, 
                         fontFamily = "Arial",
                         nodeWidth = 20, 
                         nodePadding = 10, 
                         sinksRight = FALSE, 
                         colourScale = color_scale)

# Add custom JavaScript rendering
sankey3 <- htmlwidgets::onRender(
  sankey3, 
  '
  function(el) {
    var svg = d3.select(el).select("svg");

    // --- Column title 1 (Multiline) ---
    var title1 = svg.append("text")
      .attr("x", 350)
      .attr("y", -40)
      .attr("font-size", "16px")
      .attr("font-family", "Arial")
      .attr("font-weight", "bold")
      .attr("text-anchor", "middle");

    title1.append("tspan")
      .attr("x", 350)
      .attr("dy", "1em")
      .text("Link between the phylogenetic position");
    title1.append("tspan")
      .attr("x", 350)
      .attr("dy", "1.2em")
      .text("of species ASVs");
    title1.append("tspan")
      .attr("x", 350)
      .attr("dy", "1.2em")
      .text("and their presence in a climate zone");

    // --- Column title 2 (Multiline) ---
    var title2 = svg.append("text")
      .attr("x", 700)
      .attr("y", -15)
      .attr("font-size", "16px")
      .attr("font-family", "Arial")
      .attr("font-weight", "bold")
      .attr("text-anchor", "middle");

    title2.append("tspan")
      .attr("x", 700)
      .attr("dy", "1em")
      .text("Ecological processes at play");
    title2.append("tspan")
      .attr("x", 700)
      .attr("dy", "1.2em")
      .text("within species communities");

    // --- Fix node label line breaks ---
    svg.selectAll(".node text")
      .each(function() {
        var text = d3.select(this);
        var lines = text.text().split("\\n");
        text.text("");
        lines.forEach(function(line, i) {
          text.append("tspan")
              .text(line)
              .attr("x", 25)
              .attr("dy", i === 0 ? 0 : "1.2em");
        });
      });
  }
  '
)


sankey3

# Save the Sankey diagram as an HTML file
html_file <- "figure_7.html"
saveNetwork(sankey3, file = html_file)

# Save as PNG using webshot
png_file <- "figure_7.png"
webshot(html_file, png_file, delay = 0.5, cliprect = "viewport")


