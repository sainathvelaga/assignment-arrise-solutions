With local state, two people running terraform apply at the same time on separate machines read separate local state copies, build conflicting plans, and overwrite changes—causing state corruption, drift, partial updates, or duplicate resources.

• Divergent state files: Each person works off their own local copy rather than a shared source of truth.
• Race conditions & overwrites: Concurrent applies modify resources simultaneously, and the last write can modify earlier changes.
• Broken infrastructure & drift: Half-applied changes, duplicate resources, or mismatched state files make recovery difficult. (A local lock file only protects processes sharing the exact same local directory/machine.)

 Moving state to a centralized remote backend (such as S3) ensures everyone reads and updates the same state file.
• State locking: A locking mechanism (such as DynamoDB for S3) acquires an exclusive lock during apply and blocks or errors out a second concurrent apply until the first finishes and releases the lock