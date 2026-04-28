let lastPod = null;

const podMap = {};
let podCounter = 1;

function getPodIndex(name) {
    if (!podMap[name]) {
        podMap[name] = podCounter++;
    }
    return podMap[name];
}

function formatDate(date) {
    const d = new Date(date);
    const pad = n => n.toString().padStart(2, '0');
    return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

async function loadData() {
    try {
        const res = await fetch("/api");
        const data = await res.json();

        const changed = lastPod && lastPod !== data.pod_name;
        lastPod = data.pod_name;

        render(data, changed);

    } catch {
        document.getElementById("app").innerHTML = "Backend error";
    }
}

function render(data, changed) {
    const isOk = data.status === "ok";
    const podIndex = getPodIndex(data.pod_name);

    document.getElementById("app").innerHTML = `
        <div class="panel ${isOk ? "ok" : "error"} ${changed ? "switch" : ""}">

            <div class="badge">POD #${podIndex}</div>

            <div class="project-title">
                <span class="devops">DevOps 11</span>
                <span class="final">Final Project</span>
            </div>

            <div class="status-card ${isOk ? "status-ok" : "status-error"}">
                Status ${isOk ? "200 OK" : "503 ERROR"}
            </div>

            <div class="pod-info">

                <div class="row">
                    <span class="label">Pod Name</span>
                    <span>${data.pod_name}</span>
                </div>

                <div class="row">
                    <span class="label">Pod IP</span>
                    <span>${data.pod_ip}</span>
                </div>

                ${data.uptime_seconds !== undefined ? `
                <div class="row">
                    <span class="label">Uptime</span>
                    <span>${data.uptime_seconds}s</span>
                </div>` : ""}

                <div class="row">
                    <span class="label">Time</span>
                    <span>${formatDate(data.datetime)}</span>
                </div>

                <div class="row">
                    <span class="label">Author</span>
                    <span>${data.author}</span>
                </div>

            </div>

        </div>
    `;
}

loadData();
setInterval(loadData, 2000);