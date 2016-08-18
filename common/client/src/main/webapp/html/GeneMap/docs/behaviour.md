# Behaviour

##Contents

These sections are more like a user guide:

- [Visualisation Features](#visualisation-features)
- [Annotation Visibility and Selections](#annotation-visibility-and-selections)
- [User Interaction](#user-interaction)

These sections provide more background information on how the visualisation is done:

- [Color](#color)
- [Layout](#layout)

## Visualisation Features 

- *Chromosome title*: A number, letter, roman numeral etc. identifying the chromosome.

- *Chromosome body*: A rounded rectangle whose length is proportional to size of the chromosome

- *Gene bands*: Horizontal lines across the chromosome at representing genes.

- *Gene labels*: The name of each gene can optionally be displayed with a line joining it to the corresponding gene band. 
When there are too many labels to fit on screen, groups of labels are replaced by a single label indicating the number of labels.

- *QTLs*: A rectangle is displayed for each QTL with a label where space permits.
 When there are too many QTLs to display on screen, the QTLs are grouped and a the total number of QTLs in the group is displayed.
 
## Annotation Visibility and Selections

Gene labels and QTLs are not always displayed.

### Gene labels

For an inividual gene label, visibility can be set to :

- `auto`: Display if there is space. This is default state, these genes appear coloured gray.
- `show`: Always display. Genes marked `show` appear in color.
- `hide`: Never display.

The global gene label visibility settings are:

- *Auto labels* : Display all labels set to `show` and automatically choose some labels set to `auto`.
- *Checked labels*: Display only labels set to `show`.
- *No labels*: Don't display any labels.

Whether or not an individual gene is displayed depends on both its individual visibility and the global visiblity setting.

### QTLs

QTLs an be `checked` or `unchecked`.

The global QTL visibility settings are:

- *All QTLs* : Display all QTLs, grouped if necessary
- *Checked QTLs*: Display only `checked` QTLs, with no grouping
- *No QTLs*: Don't display any QTLs.


### Gene selection

Independent of their visibility, genes can also be `selected`. 
When the network view is launched, the `selected` genes are used to generate the network.

## User Interaction

The following actions are possible:

##### Viewport control

When the mouse is not over any feature:

- *Mouse drag* : pan the viewport
- *Mouse scroll* : zoom the viewport

##### Genes

- *Click on gene band*: Toggle visbility between `show` and `hide`.
- *Drag across gene bands*: Set visibility of all included genes to `show`.

[ ... More to follow, including explanation of all the buttons ... ]

## Color

For automatically displayed genes, importance is mapped to opacity in the range 0.5 - 1.0 by the relation:

    opacity =  0.5 * ( 1 +  importance - minimum_importance ) / ( maximum_importance - minimum_importance ) )
 
If importance values are not available but the genes are ranked by importance, the opacity is generated by:

    opacity =  maxOpacity - 0.5 +  1 / (1 + Math.pow( rank, opacityFallOff) ) 
        
where `maxOpacity = 0.9`, `opacityFallOff = 3.5`.
 This function falls off sharply initially so that the first few genes are clearly distinguished, then it tends to 0.5.

[ ... More to follow, including explanation of red, orange, green colors ]

## Layout

### Length scales

Various length scales are relevant:

- Percentage of view port
- Percentage of chromosome width
- Absolute pixel size

### Gene Annotations

- Decide which labels to show
- Cluster if necessary (k-means)
- Generate positions
- Draw (with animation)

### QTL Annotations

Automatic case:

- Cluster all QTLs (hierarchical)
- Uncluster as many levels as possible
- Lay out QTLs in lanes
- Decide how many labels can be displayed
- Draw (with animation)

[ ... all the bullet points in the preceding lists could be expanded upon ... ]

### Zoom behaviour

We expect some features to increase in size as we zoom in. 
For example, if the chromosome body has been scaled up by a factor of 2, 
the length of a QTL must obviously also increase by a factor of 2 in order to appear in the right place.
The scaling relation is:

    displayed-size = original-size * zoom-scale

On the other hand, elements like text, typically remain the same absolute size in pixels in order to remain legible, 
so their size relative to the chromosome body changes.
This is advantageous because it means that when there are lots of genes close together,
 we can fit in more labels by zooming in.
 
    displayed-size = original-size
    
Some lengths don't exactly fall into either of these categories. 
For example, the width of a QTL does not convey any information (unlike the length) so, like text,
 it doesn't have to change size to match the size of other elements which have been rescaled.
On the other hand, if the width of the QTL did not change at all during zooming,
its aspect ratio would change significantly (because the length must change) and this feels unnatural.
A satisfactory compromise is to scale the QTL width proportional to a fractional power of the zoom-scale, e.g:

    displayed-size = original-size * zoom-scale^0.6
    
[ ... can apply similar arguments to some font sizes ... ]
