function xdata_point = calculate_point_from_time(ZnO,xdata_choice)
    % This functions converts one time data point of the ROIs as counter
    % figures into one index point


    openfig(['./results_ZnO/ZnO_' ZnO.DOCUscan '_' num2str(ZnO.parameter_var) 'C_ROIs as counters.fig' ]);

    haxis = gca;
    xdata = get(dataObjs, 'XData');
    %ydata = get(dataObjs, 'YData');
    
    xdata_point = find(ydata == xdata_choice);
end