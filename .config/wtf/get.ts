type Repo = { repos_url: string; login: string };

type Org = { name: string; full_name: string; url: string };

type Pulls = {
  title: string;
  html_url: string;
  user: { login: string };
  head: { repo: { full_name: string } };
};

const json = async <R>(url: string): Promise<R> => {
  const options = {
    headers: {
      "X-GitHub-Api-Version": "2022-11-28",
      Accept: "application/vnd.github+json",
      Authorization: `Bearer <personal_access_token>`,
    },
  };

  return await (await fetch(url, options)).json();
};

async function github(): Promise<void> {
  const orgs: Repo[] = await json("https://api.github.com/user/orgs");

  const repos = await Promise.all(
    orgs.map((org) => json<Org[]>(org.repos_url)),
  );

  const pulls = (await Promise.all(
    repos.flatMap((repo) => repo).map((repo) =>
      json<Pulls[]>(`${repo.url}/pulls`)
    ),
  )).filter((pr) => pr.length).flatMap((pr) => pr);

  const groupByRepo = pulls.reduce((init, pr) => {
    init[pr.head.repo.full_name] ??= [];

    init[pr.head.repo.full_name].push(pr);

    return init;
  }, {} as { [key: string]: Pulls[] });

  const grouppedList = Object.entries(groupByRepo);

  grouppedList.forEach(([key, prs], index) => {
    console.info(key);

    prs.forEach((pr, index) => {
      console.info(
        `  ${pr.title} (by @${pr.user.login})\n  ${pr.html_url}${
          index + 1 === prs.length ? "" : "\n"
        }`,
      );
    });

    if (index + 1 !== grouppedList.length) {
      console.info();
    }
  });
}

await github();
