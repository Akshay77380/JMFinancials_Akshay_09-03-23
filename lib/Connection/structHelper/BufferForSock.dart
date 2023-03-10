class BufferForSock {
  int writeCount = 0;
  int readCount = 0;
  List<int> buffer;
  final int buffSize;

  BufferForSock(this.buffSize) {
    buffer = new List<int>(buffSize);
  }

  int get getBufUsed => writeCount - readCount;

  void write(List<int> data, int length) {
    try {
      int remaining = 0;
      int copied = 0;
      remaining = (buffer.length - writeCount);
      if (remaining < length) {
        jiggleABit();
        remaining = (buffer.length - writeCount);
      }

      if (remaining < length) {
        var tempbuffer = List<int>(writeCount + length);
        tempbuffer.setRange(0, buffer.length, buffer);
        buffer = tempbuffer;
      }

      copied = length;

      buffer.setRange(writeCount, writeCount + copied, data);
      writeCount = writeCount + copied;
    } on Exception catch (e) {
      ////print(e);
    }
  }

  void read(List<int> data, int length) {
    int remaining = 0;
    int copied = 0;
    remaining = (writeCount - readCount);
    if (remaining <= 0) {
      return;
    } else {
      if (length < remaining) {
        copied = length;
      } else {
        copied = remaining;
      }
      data.setRange(0, copied, buffer, readCount);

      readCount = (readCount + copied);
      if (readCount == writeCount) {
        readCount = 0;
        writeCount = 0;
      }
      return;
    }
  }

  void peek(List<int> data, int length) {
    int remaining = 0;
    int copied = 0;
    remaining = (writeCount - readCount);
    if (remaining <= 0) {
      return;
    } else {
      if (length < remaining) {
        copied = length;
      } else {
        copied = remaining;
      }
      data.setRange(0, copied, buffer.sublist(readCount, buffer.length));
      return;
    }
  }

  void jiggleABit() {
    try {
      int dataAvail = writeCount - readCount;
      if (dataAvail <= 0) {
        return;
      }
      List<int> myBuff = new List<int>();
      myBuff.length = (buffer.length + dataAvail);
      myBuff.setRange(0, 0 + buffer.length, buffer, 0);
      buffer = myBuff;
      writeCount = (writeCount - readCount);
      readCount = 0;
    } on Exception catch (e) {
      ////print(e);
    }
  }

  void free() {
    buffer = List<int>(buffSize);
    readCount = 0;
    writeCount = 0;
  }

  void getAllData(List<int> data) {
    read(data, getBufUsed);
  }
}
