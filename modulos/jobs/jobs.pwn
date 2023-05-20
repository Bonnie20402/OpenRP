
#include "modulos\jobs\trashman\trashman.pwn"
public JobsInit() {
    printf("[jobs.pwn] Waiting for vehicles to spawn...");
    task_await(tskVehicleLoad);
    printf("[jobs.pwn] Now loading jobs...");
    TrashManInit();
    return 1;
}

