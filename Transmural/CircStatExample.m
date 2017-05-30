close all; clear all; clc;
%Test of the Circular Statitics Idea

%This is for replacing the way we analyze FS reps of ODFS

%Raw SALS Intensity Data
x = 1:180;
mu = 90.5;
sigma = 12;
normal = normpdf(x, mu, sigma);
data_raw = [normal normal];
data_raw = data_raw / 2;


%This is data coming from a section of bovine tendon
%data_raw = [27 33 40 48 58 70 84 101 121 144 171 203 240 283 333 392 459 537 626 728 845 978 1129 1300 1494 1712 1957 2231 2538 2879 3258 3678 4142 4653 5213 5827 6496 7224 8014 8868 9788 10777 11836 12967 14170 15447 16796 18218 19710 21272 22900 24591 26341 28145 29998 31893 33822 35779 37755 39740 41726 43701 45655 47578 49458 51283 53044 54727 56324 57822 59211 60483 61628 62637 63505 64223 64788 65194 65439 65520 65439 65194 64788 64223 63505 62637 61628 60483 59211 57822 56324 54727 53044 51283 49458 47578 45655 43701 41726 39740 37755 35779 33822 31893 29998 28145 26341 24591 22900 21272 19710 18218 16796 15447 14170 12967 11836 10777 9788 8868 8014 7224 6496 5827 5213 4653 4142 3678 3258 2879 2538 2231 1957 1712 1494 1300 1129 978 845 728 626 537 459 392 334 283 240 203 171 144 121 101 84 70 58 48 40 33 27 22 18 15 12 10 8 7 6 5 4 3 4 5 6 7 8 10 12 15 18 22 27 33 40 48 58 70 84 101 121 144 171 203 240 283 334 392 459 537 626 728 845 978 1129 1300 1494 1712 1957 2231 2538 2879 3258 3678 4142 4653 5213 5827 6496 7224 8014 8868 9788 10777 11836 12967 14170 15447 16796 18218 19710 21272 22900 24591 26341 28145 29998 31893 33822 35779 37755 39740 41726 43701 45655 47578 49458 51283 53044 54727 56324 57822 59211 60483 61628 62637 63505 64223 64788 65194 65439 65520 65439 65194 64788 64223 63505 62637 61628 60483 59211 57822 56324 54727 53044 51283 49458 47578 45655 43701 41726 39740 37755 35779 33822 31893 29998 28145 26341 24591 22900 21272 19710 18218 16796 15447 14170 12967 11836 10777 9788 8868 8014 7224 6496 5827 5213 4653 4142 3678 3258 2879 2538 2231 1957 1712 1494 1300 1129 978 845 728 626 537 459 392 334 283 240 203 171 144 121 101 84 70 58 48 40 33 27 22 18 15 12 10 8 7 6 5 4 3 4 5 6 7 8 10 12 15 18 22];
data_raw = [467 479 498 509 516 523 546 548 542 547 542 548 560 560 574 591 613 640 636 641 646 647 632 632 632 634 622 609 589 571 554 556 551 549 545 562 572 575 587 586 586 598 588 586 582 584 590 588 580 589 585 595 609 610 621 624 623 631 631 638 630 634 633 639 645 649 658 668 663 672 678 669 657 652 633 640 853 980 1130 1217 1325 1368 1291 1155 1017 798 692 601 569 531 506 497 483 476 472 464 461 456 448 459 450 436 438 426 424 405 404 401 391 392 393 389 382 376 377 378 381 388 390 393 398 410 412 413 410 419 422 420 421 409 400 405 395 384 377 369 368 365 357 359 350 349 347 344 348 345 343 350 357 364 362 367 368 371 376 381 383 382 386 396 405 409 411 415 419 418 421 416 414 412 415 421 429 440 455 472 483 496 507 518 521 520 526 528 527 528 531 534 536 547 544 540 546 546 552 544 545 542 532 538 542 550 544 547 551 565 574 576 576 578 576 583 580 572 566 559 558 548 538 520 511 516 508 505 508 517 519 520 519 523 520 524 526 523 525 522 511 515 511 512 495 485 479 476 479 488 497 514 545 572 608 614 609 609 592 577 560 540 531 511 500 492 475 478 478 470 478 485 485 480 478 477 461 449 443 440 436 423 415 424 414 406 409 399 401 385 384 384 377 375 374 368 361 366 376 381 386 393 402 407 409 419 414 409 409 415 418 413 422 422 422 444 441 446 447 447 441 437 426 421 407 407 411 400 401 399 391 388 389 387 377 376 371 368 368 369 372 377 380 389 398 405 411 419 420 423 441 440 446 448 455 454 445 444 450 444 442 446 449 459];
%data_raw = circshift(data_raw', 45)';


%New Data point
examplePoint = data_point;
examplePoint.intensity_data = data_raw;

%Normalize data and generate fourier
examplePoint.Normalize;
%examplePoint.odd = data_raw;
examplePoint.GenerateFourier(14);
examplePoint.ComputeStats;


%plot ODF and Fourier Series Representation of the ODF
figure;
set(gca,'fontsize',18)
hold on;
%plot(examplePoint.theta, examplePoint.odd);
plot(examplePoint.theta, abs(examplePoint.odf));
hold off;
%legend('ODF', 'Fourier series representation of the ODF');
legend('Orientation Distribution Function');
xlabel('Degrees (Radians)');
ylabel('ODF');


%% New way - Suggestion from Stack Exchange

angles = examplePoint.theta;
weights = abs(examplePoint.odf);
doubleAngles = 2.*angles;

xVect = mean(weights.*cos(doubleAngles));
yVect = mean(weights.*sin(doubleAngles));

prefD = atan2(yVect, xVect) / 2;

%For Plotting
angles = [prefD (prefD+pi)];
value = max(examplePoint.odf);
dist = [value value];

%For plotting (rd 2)
angles2 = [prefD (prefD+pi)];
dist2 = [1 0];

figure;
polarplot(examplePoint.theta, examplePoint.odf);
hold on;
%polarplot(angles, dist);
polarplot(angles2, dist2);
hold off;
legend('Orientation Distribution Function', 'Preferred Direction Vector');
set(gca,'fontsize',18)



%% Method established in Direction Statistics, Mardia and Jupp

angles = 2*examplePoint.theta;
weights = abs(examplePoint.odf);

C_mean = mean(weights.*cos(angles));
S_mean = mean(weights.*sin(angles));

R = ((C_mean^2)+(S_mean^2))^(1/2);

Vector = C_mean + S_mean*1i;

if C_mean < 0
    PrefAngle = (atan(S_mean/C_mean) + pi)/2;
else
    PrefAngle = atan(S_mean/C_mean)/2;
end



%% Max
weights =  [zeros(1,20) (90/pi) zeros(1,159)];
weights = [weights weights];

maxArea = reportArea(examplePoint.theta, weights);

c = []; s = [];
for i = 1:length(weights)
    %if weights(i) ~= 0
        c = [c weights(i)*cos(angles(i))];
        s = [s weights(i)*sin(angles(i))];
    %end
end

C_mean = mean(c);
S_mean = mean(s);

R_max = ((C_mean^2)+(S_mean^2))^(1/2);

figure;
polarplot(examplePoint.theta, weights, 'LineWidth', 2);
title('Maximum NOI');
set(gca,'fontsize',18)

%% Min
weights =  repmat((180/(359*pi)),[1,360]);
%weights = [weights weights];

minArea = reportArea(examplePoint.theta, weights);

C_mean = mean(weights.*cos(angles));
S_mean = mean(weights.*sin(angles));



R_min = ((C_mean^2)+(S_mean^2))^(1/2);

figure;
polarplot(examplePoint.theta, weights, 'LineWidth', 2);
title('Min NOI on a Directional Distribution');
set(gca,'fontsize',18)


NOI = 100*((R-R_min)/R_max-R_min);

%}

%% Using toolbox
angles = examplePoint.theta;
values = abs(examplePoint.odf);

[r,mean] = circ_axialmean(angles,values,2,1);
[std, std0] = circ_std(angles,values,[],2);
[skew,skew0] = circ_skewness(angles,values,2);
[kurt,kurt0] = circ_kurtosis(angles,values,2);




%mean = circ_mean(alpha, values,2)/2;

%stats = circ_stats(alpha, values');