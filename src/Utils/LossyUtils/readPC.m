function [V, C, N] = readPC(filename)
    pc = pcread(filename);
    V = double(pc.Location);
    C = double(pc.Color);
    N = double(pc.Normal);
end