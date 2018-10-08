Update time 20180827
==========
(1) Useful scripts in speed/worm position calculation
(2) Add active contour based segmentation code


Copy of the image processing codes (@2018-0705)
==========

Some codes should be modified to get better performance:
(1) Boundary extraction;
(2) Neuron extraction;
(3) Neuron tracking (based on extraction, boundary, neuron offset and so on)
    Many useful data can be involved in tracking. Make some strategies to do better
(4) Worm segmentation; 
    Use active contour method or optimization method to segment worm region;