package require PWI_Glyph 2.17.2

#
# This script deletes all break points on connectors specified by the user. The
# user can either run the script on connectors selected at runtime, or can
# select the desired connectors after the script has been started. In the case
# that the user has preselected the connectors, the script will delete break
# points contains by the selected connectors and exit. In either case, the
# script does not ask the user for more connectors.

# Run script on selected connectors if there are any.
set mask [pw::Display createSelectionMask -requireConnector {Dimensioned}]
pw::Display getSelectedEntities -selectionmask $mask connectors

set nCons [llength $connectors(Connectors)]

# If no connectors were selected at runtime, ask user to select them.
if {$nCons == 0} {
  # Create selection mask for connectors.
  set connectorMask [pw::Display createSelectionMask -requireConnector Dimensioned]

  if {![pw::Display selectEntities -selectionmask $connectorMask \
      -description "Select connectors for break point deletion" connectors] } {
    set connectors(Connectors) ""
  }
}

set nCons [llength $connectors(Connectors)]

puts "Deleting break points from $nCons [expr ($nCons==1)?"connector":"connectors"]... "

set modifyMode [pw::Application begin Modify $connectors(Connectors)]

# Delete break points.
foreach con $connectors(Connectors) {
  $con removeAllBreakPoints
}

$modifyMode end
unset modifyMode

puts "Break points deleted"
