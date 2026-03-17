|IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning

|Required Tools:serena (semantic code ops)|context7 (3rd-party docs)|sequential-thinking (decisions)
|Language Policy:Chinese for Q&A|English for code/docs/tech discussions
|Compression Rule:Follow ~/.config/opencode/AGENTS-compression-guide.md (pipe-index format, concise, no prose/code blocks)
|Memory Policy:session-start→search_nodes for relevant user/project context before acting|Store: key decisions, user preferences, learned patterns, architecture insights|Entity types: preference, decision, pattern, concept, project, convention|Link entities via create_relations (active voice)|Update via add_observations when facts evolve, don't duplicate|Read-before-write: search_nodes before create to avoid duplicates

## 代码质量准则

### 重构纪律
- 以微小步伐修改，保持可观察行为不变
- 重构与功能修改不混在同一次提交中
- 先让代码结构适合添加新特性，再添加特性
- 破坏程序的最好方法之一就是以改进之名大动其结构

### 函数设计
- 短小、只做一件事、无副作用
- 以「做什么」命名而不是「怎么做」
- 避免超过 3 个参数，相关参数组提取为对象
- 不使用布尔标识参数，应拆分为独立方法
- 查询方法与修改方法分离

### 坏代码信号
- 重复代码、过长方法、过大的类、过长参数列表
- 霰弹式修改（一个变化导致多处修改）→ 抽取到一处
- 依恋情结（频繁调用其他类）→ 移到数据所在处
- 过度耦合的消息链（`a.get().get().get()`）→ 遵循迪米特法则

### 条件与错误处理
- 用卫语句取代嵌套条件（避免 else，提前 return）
- 用多态取代 switch/if-else 分支
- 封装复杂条件表达式为独立方法
- 用异常替代错误码，不返回 null、不传递 null

### 通用原则
- 多用组合少用继承
- 保留旧接口调用新接口，标记旧接口为已过时
- 以字面常量代替魔法数
- 测试代码同样重要，三要素：可读性、可读性、可读性
