%EE 372: This code was written for A1-GOL.

%JNM 01/30/2021

%%Description: This code simulates Conway's Game of Life. Based on the
%following four rules, cells evolve to create unique patterns determined
%by initial conditions.
    %Rules:
    %1.) Alive cells with less than two live neighbors will die in the next
    %generation
    %2.) Alive cells with 2 or 3 alive neighbors will stay alive in the next
    %generation
    %3.) Alive cells with more than 3 alive neighbors will die in the next
    %generation
    %4.) Dead cells witih 3 alive neighbors will be alive in the next
    %generation

%%Housekeeping
%Global settings and initializations

clear; clc; clf;

%%Sandbox
%Construct 100x100 arena
C = randi([0 1], 102, 102);                         %creates a 102x102 arena with randomly selected alive cells
C(1,:) = zeros(1, 102);                             %top border as zeros
C(:,1) = zeros(102, 1);                             %left border as zeros
C(102,:) = zeros(1, 102);                           %bottom border as zeros
C(:, 102) = zeros(102, 1);                          %right border as zeros

%set-up video file to record
video = VideoWriter("GoLDemo", 'Uncompressed AVI'); %saves .avi video as 'GoLDemo'
video.FrameRate = 5;                                %five generations per frame
open(video)                                         %start recording

%%Synthesis
%create code to simulate games behavior

counter = 0;                                        %to be used as a counter to track cells

for n = 1:100                                       %generation for-loop; 100 generations
    D = zeros(102, 102);                            %creates a placeholder matrix for new states to be saved in
    r = 2;                                          %ensures row(1) cells will not be evaluated
    c = 2;                                          %ensures col(1) cells will not be evaluated
    for i = 1:9000                                  %for-loop to check cells within border
        cell = C(r, c);                             %saves cell state to a variable
        if c == 101                                 %if cell is on the edge of the right border, move to edge of left border
            c = 2;
            r = r + 1;                              %go to next row when at end of column
        end
        %number of alive cells around evaluated cell
        cond = C(r-1, c-1) + C(r-1, c) + C(r-1, c+1) + C(r, c-1) + C(r, c+1) + C(r+1, c-1) + C(r+1, c) + C(r+1, c+1);
        if cell == 1                                %if the cell is alive
            if cond < 2                             %Rule 1
                D(r, c) = 0;                        %cell is now dead
                c = c + 1;                          %move on to next cell
            elseif cond == 2 || cond == 3           %Rule 2
                D(r, c) = 1;                        %cell is still alive
                c = c + 1;                          %move on to next cell
            else                                    %Rule 3
                D(r, c) = 0;                        %cell is now dead
                c = c + 1;                          %move on to next cell
            end
        elseif cell == 0                            %if cell is dead
            if cond == 3                            %Rule 4
                D(r, c) = 1;                        %cell is now alive
                c = c + 1;                          %move on to next cell
            else
                D(r, c) = 0;                        %cell is still dead
                c = c + 1;                          %move on to next cell
            end
        end
        counter = counter + 1;                      %increase counter by one
        cond = 0;                                   %reset cond variable to zero
    end
    C = D;                                          %save new matrix over last generation
    
    frame = imagesc(C);                             %save uifile to a variable
    drawnow                                         %create image from uifile
    F(n) = getframe(gcf);                           %save image to array F
    writeVideo(video, F)                            %write array value to video file
    
end

%stop recording video and save
close(video) 

%save raw data
save('GameOfLife.mlx', '-ascii')