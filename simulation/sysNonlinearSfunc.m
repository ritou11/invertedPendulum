function sysNonlinearSfunc(block)

    setup(block);

end

function setup(block)

    %% Register number of dialog parameters   
    block.NumDialogPrms = 7;

    %% Register number of input and output ports
    block.NumInputPorts  = 3;
    block.NumOutputPorts = 4;

    %% Setup functional port properties to dynamically
    %% inherited.
    block.SetPreCompInpPortInfoToDynamic;
    block.SetPreCompOutPortInfoToDynamic;

    block.InputPort(1).Dimensions        = 1;
    block.InputPort(1).SamplingMode = 'Sample';
    block.InputPort(1).DirectFeedthrough = false;
    
    block.InputPort(2).Dimensions        = 4;
    block.InputPort(2).SamplingMode = 'Sample';
    block.InputPort(2).DirectFeedthrough = false;

    block.InputPort(3).Dimensions        = 4;
    block.InputPort(3).SamplingMode = 'Sample';
    block.InputPort(3).DirectFeedthrough = false;
    
    block.OutputPort(1).Dimensions       = 1;
    block.OutputPort(1).SamplingMode = 'Sample';
    block.OutputPort(2).Dimensions       = 1;
    block.OutputPort(2).SamplingMode = 'Sample';
    block.OutputPort(3).Dimensions       = 1;
    block.OutputPort(3).SamplingMode = 'Sample';
    block.OutputPort(4).Dimensions       = 1;
    block.OutputPort(4).SamplingMode = 'Sample';

    %% Set block sample time to continuous
    block.SampleTimes = [0 0];

    %% Setup Dwork
    block.NumContStates = 4;

    %% Set the block simStateCompliance to default (i.e., same as a built-in block)
    block.SimStateCompliance = 'DefaultSimState';

    %% Register methods
    block.RegBlockMethod('InitializeConditions',    @InitConditions);  
    block.RegBlockMethod('Outputs',                 @Output);  
    block.RegBlockMethod('Derivatives',             @Derivative);

end


function InitConditions(block)

    %% Initialize Dwork
    block.ContStates.Data(1) = 0; % x
    block.ContStates.Data(2) = 0; % dx
    block.ContStates.Data(3) = block.DialogPrm(6).Data; % phi
    block.ContStates.Data(4) = 0; % dphi
  
end

% ContStates = [x dx phi dphi]
function Output(block)

    block.OutputPort(1).Data = block.ContStates.Data(1); % x
    block.OutputPort(2).Data = block.ContStates.Data(2); % dx
    block.OutputPort(3).Data = mod(block.ContStates.Data(3) + pi, 2*pi) - pi;% phi
    block.OutputPort(4).Data = block.ContStates.Data(4); % d phi
    
end

function Derivative(block)


    M = block.DialogPrm(1).Data;
    m = block.DialogPrm(2).Data;
    b = block.DialogPrm(3).Data;
    l = block.DialogPrm(4).Data;
    I = block.DialogPrm(5).Data;
    g = 9.80;
    useAcc = block.DialogPrm(7).Data;

    u =  block.InputPort(1).Data;

    x = block.ContStates.Data(1);
    dx = block.ContStates.Data(2);
    phi = block.ContStates.Data(3);
    dphi = block.ContStates.Data(4);
    
    if(useAcc)
        dd = [u
            (m*l*u*cos(phi)+m*g*l*sin(phi))/(I+m*l^2)];
    else
        A = [M+m, -m*l*cos(phi); -m*l*cos(phi), I+m*l^2];
        b = [u-b*dx-m*l*dphi^2*sin(phi); m*g*l*sin(phi)];
        dd = A \ b; 
    end

    block.Derivatives.Data(1) = dx + block.InputPort(3).Data(1); % d x
    block.Derivatives.Data(2) = dd(1) + block.InputPort(3).Data(2); % dd x
    block.Derivatives.Data(3) = dphi + block.InputPort(3).Data(3); % d phi
    block.Derivatives.Data(4) = dd(2) + block.InputPort(3).Data(4); % dd phi

    flag = 0;
    for i=1:4
        if(abs(block.InputPort(2).Data(i)) > 1e-6)
            flag = 1;
        end
    end
    if(flag)
        for i=1:4
            if(abs(block.InputPort(2).Data(i)) > 1e-6)
                block.Derivatives.Data(i) = 100 * (block.InputPort(2).Data(i) - block.ContStates.Data(i));
            else
                block.Derivatives.Data(i) = 0;
            end
        end
    end
end