FEMM 4.2 14Nov2013
David Meeker
dmeeker@ieee.org

15Nov2013:

* Changed the way that errors are trapped in Matlab/Octave and Scilab
  implementations so that errors that would normally display as message
  boxes in a normal GUI session instead get returned as errors to
  Matlab/Octave or Scilab.  Errors can then be trapped, e.g. by using a
  try/catch block.

07Nov2013:

* Fixed instances of GetWindowLong and SetWindowLong which caused the x64
  build to crash when running on Linux via Wine.
* Fixes to eo_blockintegral and co_blockintegral functions. Previously wouldn't 
  allow integration (e.g. for Weighted Stress Tensor force) if the only selected 
  area was a conductor surface.

25Aug2013:

* Changed IABCs to support either a Dirichlet or Neumann outer edge.  This
  is useful for electrostatic problems.

04Aug2013:

* Added mi_selectcircle, mi_selectrectangle and friends to programmatically
  select regions.
* Changed .dxf import so that objects assigned layers are imported as
  grouped being in the same group.
* Added new "Improvised Asymptotic Boundary Condition" button and mi_makeABC
  and friends Lua funtions as an alternate way of solving unbounded
  problems.

11Apr2012:

* Can turn off "smart meshing" via a Preferences selection on the "General Attributes"
  tab by unchecking "use smart meshing"
* Fixed a newly introduced bug where an erroneous resistive loss is computed for AC
  problems in regions where conductivity = 0
* Fixed mi_readdxf problem described as Bug 18 in the bug tracker.

01Oct2011:

* Fixed error in reported flux linkage. Flux linkage for stranded regions 
  carrying zero current is not reported correctly for AC problems.
* The Lua "format" command did not work properly with complex number--it 
  stripped off the imaginary part of the number.  This is now fixed.
* The units reported for some heat flow block integral results were erroneous. 
  This has now been rectified.
* 64-bit version of FEMM 4.2 is now available.
* FEMM has been modified to allow multiple instance of FEMM to run at the 
  same time via ActiveX.  For example, This allows multiple instance of FEMM
  to be controlled by one instance of Matlab or Octave.
* FEMM 42 09Nov2010 asks for Mathematica integration when using the silent 
  install method. The installer script has been modified so that the silent
  install assumes that Mathematica is not available, letting the installation
  complete without requiring operator intervention.
* Default material.  A feature has been added which allows one block label to
  be designated as the default block label. Any unlabeled blocks are then
  assumed to be tagged by the default block label.
* In the current flow problem type, line plots of quantities normal and
  tangential to a user-define contour were messed up because the normal
  and tangential directions were computed incorrectly.  This is now fixed.
* The "default" mesh size has been changed.  In previous builds, using the
  default mesh size nearly always resulted in a mesh that was too coarse to
  give accurate results. The default mesh size has been changed so that
  specifying the default mesh size is adequate for most applications.
  Note: can use the <F3> and <F4> keys to uniformly refine and coarsen the
  mesh for the entire model with one keystroke.
* Added automatic refinement of the mesh near corners.  This refinement 
  improves convergence of results like force, stored energy, etc.
* Changed the way that the maximum flux density is computed for flux density
  plotting purposes.  With the automatic refinement of corners, small elements
  with high flux densities can appear in corners. The modified algorithm
  discounts these small corner elements when picking a maximum for the purposes
  of picking plot contours.
* Changed the key that is used to break out of Lua scripts to ESC from BREAK.
  Many keyboards don't have a BREAK key anymore, so it made sense to make this
  change.
* Changed the selection rectangle to a dotted line so that it would 
  render faster.
* Modified the DXF import to understand closed POLYLINE entities.  Previously,
  only open POLYLINE entities were supported.
* Fixed problem with functionality that creates rounded corners (i.e.
  the functionality invoked by mi_createradius) where the program would not
  allow a radius to be created if the intersection was between a line
  segment and an arc segment if the line segment laid along a ling that
  passed through the center of the circle associated with the arc segment.
* Default install directory changed to c:\femm42 to avoid directory
  permissions problems in Windows 7.
  
09Nov2010:

* Added a set of Scilab functions for interfacing with FEMM. These
  functions were tested using Scilab 5.2.2. The descriptions of these
  functions are identical to those described in the OctaveFEMM
  documentation. Example Scilab scripts are in the femm42/examples directory
  and have a .sce file extension and can be run by typing:
  exec('examplename.sce',-1)
  at the Scilab commandline. If you did not install FEMM to the default
  c:\Program Files\femm42 directory, you'll need to change the first line
  of the *.sce files that loads the FEMM library so that it points to the
  correct library location.

11Oct2010:

* Fixed bug in values of |H| reported in the Output Window for time harmonic
  magnetic problems.
* Fixed bug where in some plots, units of H given as A/m^2 instead of A/m
* Fixed error in mo_showvectorplot Matlab/Octave function.  Also fixed
  similar errors in co_showvectorplot, ho_showvectorplot, eo_showvectorplot
* Fixed messed-up definitions of the Lua functions ei_defineouterspace,
  ei_attachouterspace, and ei_detachouterspace
* Installer now prompts for whether or not Mathetmatica support is to be
  included. If Mathematica support is selected, a version of FEMM is
  installed that assumes the availability of ML32I2.DLL, a DLL installed by
  Mathematica. Otherwise, a version of FEMM is installed that doesn't need
  the Mathlink DLL.
* Re-wrote the GetIntersection routine that finds intersections between two
  line segments.  In some uncommon circumstances, the routine could create 
  extra points when the geometry was moved or rotated.
* Added extra Lua functions mi_getmaterial, ei_getmaterial, hi_getmaterial,
  and ci_getmaterial to fetch material definitions from the materials
  library on disk.  Analogous functions were also added to the Matlab/Octave
  and Mathematica interfaces.

02Nov2009:

* Added the Lua commands mi_setgroup, ei_setgroup, hi_setgroup, ci_setgroup
  that assign all selected items to the group number specified by the
  argument to the function.
* Fixed a bug that caused an incorrect permeability to be reported for
  nonlinear materials at points where the flux density is less than 10nT.
* Fixed bugs with ci_addconductor and ci_modifyconductor Lua functions.
* Fixed bug with CIAddMaterial function in MathFEMM

15Jul2009: Several minor changes have been made versus the 01Apr2009 release:

* Added the following Lua commands that allow direct access to finite
  element mesh information:
  mo_numnodes, mo_numelements, mo_getnode, mo_getelement,
  eo_numnodes, eo_numelements, eo_getnode, eo_getelement,
  ho_numnodes, ho_numelements, ho_getnode, ho_getelement,
  co_numnodes, co_numelements, co_getnode, co_getelement.
  There are Matlab/Octave and Mathematica analogs of these commands, too.
* Made a few more performance tweaks to the Mathematica interface.
* Fixed bug in computation of heat flux passing through a constant
  temperature-type "conductor property"
* Included a new selection of soft magnetic materials in the magnetic 
  materials library. The BH curves for these materials were obtained by
  digitizing the curves picutured in Figure 17, "Direct current 
  magnetization curves for various magnetic materials", Metals Handbook,
  8th ed, Vol. 1, p. 792.  These curves represent a wide variety of
  materials, and the curves are defined to very high flux levels at
  which all materials are fully saturated.
