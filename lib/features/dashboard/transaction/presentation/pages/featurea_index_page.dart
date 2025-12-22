body: Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FeatureAHeader(),
      const SizedBox(height: 24),
      _transferButton(),
      const SizedBox(height: 28),
      const Text(
        'Transaksi Terakhir',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: BlocBuilder<FeatureABloc, FeatureAState>(
          builder: (context, state) {
            if (state is FeatureALoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeatureALoaded) {
              return ListView.builder(
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  return FeatureATile(
                    data: state.transactions[index],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    ],
  ),
),
