### ` 1️⃣ Client sends request `
User opens: This DNS name points to CloudFront
 ```bash
https://dev.daws86s.fun
 ```

---

### ` 2️⃣ CloudFront checks cache`
CloudFront checks:
- **Do I already have a cached copy?** 
- **Does request match /media/* → use optimized caching** 
- **Or match /images/*.** 
- **Otherwise use default behavior** 
- **If cached → respond immediately.** 
- **If not cached → CloudFront must fetch from the origin.** 

---

### `3️⃣ CloudFront contacts the ORIGIN (Frontend ALB)`

CloudFront makes a backend request to:
 ```bash
https://roboshop-dev.daws86s.fun
 ```

Because your origin config says:
 ```bash
origin_protocol_policy = "https-only"
https_port             = 443
 ```

So CloudFront connects via:
 ```bash
HTTPS (TLS1.2)
 ```
---

### `⭐ How the ALB knows what to do when CloudFront sends the Host header `
When CloudFront contacts your ALB, it sends:
 ```bash
Host: roboshop-dev.daws86s.fun
 ```
---

### `4️⃣ ALB forwards request to EC2 instances or ECS services`

Your Frontend ALB  has:
HTTPS listener (443)

Rules (probably route everything to "frontend" target group)

Target group with:
EC2 instances or ECS tasks running "frontend" app

The frontend app returns a response:
- **HTML**
- **JS**
- **CSS**
- **API calls forwarded to backend ALB etc.**

So the flow is:
 ```bash
CloudFront → Frontend ALB → EC2 (UI App)
 ```
---

### `5️⃣ ALB sends response → CloudFront`

ALB returns page → CloudFront receives it → caches it (based on your caching rules):
- **/images/* → cached heavily
- **/media/* → cached
- **everything else → cache disabled (probably HTML)

---

### `6️⃣ CloudFront returns response → Client (User)`

User gets the HTML page.
For static assets (JS, CSS, images), CloudFront will usually serve cached content next time.

### `🎯 DIAGRAM `

 ```bash
User
  |
  ↓
Route53 (A alias)
  |
  ↓
CloudFront  ← caches static content
  |
  ↓  HTTPS request
Frontend ALB (Origin)
  |
  ↓  forwards request
Frontend EC2 / ECS
  |
  ↓
Response back → CloudFront → User

 ```
---
 ### `⭐CloudFront acts as the client → it connects to ALB via HTTPS → ALB processes the request → sends the response back to CloudFront.`
---
 ### ` ⭐ Why CloudFront + ALB is used? `

CloudFront gives:  CloudFront = performance + security + global reach. It protects your ALB and speeds up your app.     

 ```bash
- **Global caching(CDN)**       London user → London CloudFront → NOT from US server This makes your app load 2–10x faster.
- **Lower latency**             CloudFront keeps frequently accessed files closer to users.
- **DDoS protection**           It blocks bots / attack traffic before it even reaches your ALB.
- **GZip/Brotli compression**   CloudFront compresses files → faster delivery.
- **TLS termination at edge**   CloudFront handles HTTPS encryption so your ALB gets fewer heavy SSL operations.
- **Failover logic**            CloudFront → automatically switches to backup origin (another ALB, S3, etc.)
 ```

ALB gives:      smart routing + backend load balancing
 ```bash
- **Server-side routing**             ALB can route traffic based on:Path(/api→ API servers  ,/frontend servers ),Hostnames
- **Path-based rules**
- **Container / EC2 target groups**   Load Balancing
- **HTTP/HTTP2/HTTPS support**
 ```
Together, CloudFront handles the "EDGE"
ALB handles the "APPLICATION".
---